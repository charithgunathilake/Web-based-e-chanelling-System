package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.model.*;
import com.echannel.service.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Unified Single-Page Application (SPA) Portal Controller.
 * Handles the unified multi-role dashboard at /portal and profile management.
 */
@Controller
public class PortalController {

    @Autowired private UserService userService;
    @Autowired private PatientService patientService;
    @Autowired private DoctorService doctorService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private HealthRecordService healthRecordService;
    @Autowired private PrescriptionService prescriptionService;
    @Autowired private BranchService branchService;
    @Autowired private FeedbackService feedbackService;
    @Autowired private NotificationService notificationService;

    private User currentUser(HttpSession session) {
        if (session == null) return null;
        User u = (User) session.getAttribute("currentUser");
        if (u == null) u = (User) session.getAttribute("loggedInUser");
        return u;
    }

    @GetMapping("/portal")
    public String portal(@RequestParam(value = "tab", required = false) String tab,
                         @RequestParam(value = "specialty", required = false) String specialty,
                         @RequestParam(value = "date", required = false) String date,
                         HttpSession session, Model model) throws DatabaseException {
        User user = currentUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        // Always pass current user details to model
        model.addAttribute("currentUser", user);
        model.addAttribute("activeTab", tab);

        String role = user.getRole();
        switch (role) {
            case "PATIENT" -> populatePatientData(user, specialty, model);
            case "DOCTOR" -> populateDoctorData(user, model);
            case "PHARMACIST" -> populatePharmacistData(model);
            case "RECEPTION" -> populateReceptionData(date, model);
            case "ADMIN" -> populateAdminData(model);
            case "OPERATIONS_MANAGER" -> populateOperationsData(model);
        }

        return "dashboard/portal";
    }

    private void populatePatientData(User user, String specialty, Model model) throws DatabaseException {
        Patient patient = patientService.findByUserId(user.getUserId());
        model.addAttribute("patient", patient);
        if (patient != null) {
            model.addAttribute("appointments", appointmentService.forPatient(patient.getPatientId()));
            model.addAttribute("prescriptions", prescriptionService.forPatient(patient.getPatientId()));
            model.addAttribute("records", healthRecordService.historyForPatient(patient.getPatientId()));
        }
        model.addAttribute("doctors", doctorService.searchBySpecialty(specialty));
        model.addAttribute("specialty", specialty);
        model.addAttribute("notifications", notificationService.forUser(user.getUserId()));
    }

    private void populateDoctorData(User user, Model model) throws DatabaseException {
        Doctor doctor = doctorService.findByUserId(user.getUserId());
        model.addAttribute("doctor", doctor);
        if (doctor != null) {
            model.addAttribute("appointments", appointmentService.forDoctor(doctor.getDoctorId()));
            model.addAttribute("schedule", doctorService.scheduleForDoctor(doctor.getDoctorId()));
            model.addAttribute("avgRating", feedbackService.averageRating(doctor.getDoctorId()));
        }
        model.addAttribute("rooms", branchService.allRooms());
    }

    private void populatePharmacistData(Model model) throws DatabaseException {
        model.addAttribute("pending", prescriptionService.pendingQueue());
    }

    private void populateReceptionData(String date, Model model) throws DatabaseException {
        LocalDate d = (date == null || date.isBlank()) ? LocalDate.now() : LocalDate.parse(date);
        model.addAttribute("today", appointmentService.forDate(LocalDate.now()));
        model.addAttribute("appointments", appointmentService.forDate(d));
        model.addAttribute("selectedDate", d);
        model.addAttribute("doctors", doctorService.allDoctors());
    }

    private void populateAdminData(Model model) throws DatabaseException {
        model.addAttribute("users", userService.findAll());
        model.addAttribute("branches", branchService.allBranches());
        model.addAttribute("rooms", branchService.allRooms());
        model.addAttribute("userCount", userService.findAll().size());
        model.addAttribute("branchCount", branchService.allBranches().size());
    }

    private void populateOperationsData(Model model) throws DatabaseException {
        model.addAttribute("rooms", branchService.allRooms());
        model.addAttribute("totalAppointments", appointmentService.allAppointments().size());
        Map<String, Double> doctorRatings = new LinkedHashMap<>();
        for (Doctor d : doctorService.allDoctors()) {
            Double avg = feedbackService.averageRating(d.getDoctorId());
            doctorRatings.put(d.getFullName() + " (" + d.getSpecialty() + ")", avg == null ? 0.0 : avg);
        }
        model.addAttribute("doctorRatings", doctorRatings);
        model.addAttribute("feedbackList", feedbackService.allFeedback());
    }

    /** Profile settings update endpoint. */
    @PostMapping("/portal/profile/update")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam String email,
                                @RequestParam String phone,
                                @RequestParam(required = false) String nic,
                                @RequestParam(required = false) String address,
                                @RequestParam(required = false) String newPassword,
                                HttpSession session, Model model) throws DatabaseException {
        User user = currentUser(session);
        if (user == null) return "redirect:/login";

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);

        if (newPassword != null && !newPassword.isBlank()) {
            user.setPassword(newPassword);
            userService.resetPassword(user.getUserId(), newPassword);
        }
        userService.updateRoleAndStatus(user.getUserId(), user.getRole(), user.isActive());

        // Update Patient profile if patient
        if ("PATIENT".equals(user.getRole())) {
            Patient patient = patientService.findByUserId(user.getUserId());
            if (patient != null) {
                patient.setNic(nic);
                patient.setAddress(address);
                // save patient updates
            }
        }

        session.setAttribute("currentUser", user);
        session.setAttribute("loggedInUser", user);
        return "redirect:/portal?tab=profile&updated=1";
    }
}
