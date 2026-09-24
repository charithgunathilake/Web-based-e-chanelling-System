package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.model.*;
import com.echannel.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/patient")
public class PatientController {

    @Autowired private PatientService patientService;
    @Autowired private DoctorService doctorService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private HealthRecordService healthRecordService;
    @Autowired private PrescriptionService prescriptionService;
    @Autowired private FeedbackService feedbackService;
    @Autowired private NotificationService notificationService;

    private User currentUser(HttpSession session) {
        return (User) session.getAttribute("loggedInUser");
    }

    @GetMapping("/dashboard")
    public String dashboard() {
        return "redirect:/portal";
    }

    /** Use Case 2 step 1: Search Doctors & Book Appointment. */
    @GetMapping("/search-doctors")
    public String searchDoctors(@RequestParam(required = false) String specialty, Model model) throws DatabaseException {
        model.addAttribute("doctors", doctorService.searchBySpecialty(specialty));
        model.addAttribute("specialty", specialty);
        return "patient/search-doctors";
    }

    @GetMapping("/book/{doctorId}")
    public String bookAppointmentPage(@PathVariable Integer doctorId, Model model) throws DatabaseException {
        model.addAttribute("doctor", doctorService.allDoctors().stream()
                .filter(d -> d.getDoctorId().equals(doctorId)).findFirst().orElse(null));
        model.addAttribute("slots", doctorService.bookableSlots(doctorId));
        return "patient/book-appointment";
    }

    @PostMapping("/book")
    public String confirmBooking(@RequestParam Integer scheduleId, HttpSession session, Model model)
            throws DatabaseException {
        User user = currentUser(session);
        Patient patient = patientService.findByUserId(user.getUserId());
        String error = appointmentService.bookAppointment(patient.getPatientId(), scheduleId);
        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("slots", java.util.Collections.emptyList());
            return "redirect:/patient/dashboard?error=" + java.net.URLEncoder.encode(error, java.nio.charset.StandardCharsets.UTF_8);
        }
        return "redirect:/patient/dashboard?booked=1";
    }

    @PostMapping("/cancel/{appointmentId}")
    public String cancelAppointment(@PathVariable Integer appointmentId) throws DatabaseException {
        appointmentService.updateStatus(appointmentId, "CANCELLED");
        return "redirect:/patient/dashboard";
    }

    /** Use Case 3: View Medical History (read-only for the patient). */
    @GetMapping("/medical-history")
    public String medicalHistory(HttpSession session, Model model) throws DatabaseException {
        User user = currentUser(session);
        Patient patient = patientService.findByUserId(user.getUserId());
        model.addAttribute("records", healthRecordService.historyForPatient(patient.getPatientId()));
        model.addAttribute("prescriptions", prescriptionService.forPatient(patient.getPatientId()));
        return "patient/medical-history";
    }

    /** Use Case 6: Submit & Manage Patient Feedback. */
    @GetMapping("/feedback")
    public String feedbackPage(HttpSession session, Model model) throws DatabaseException {
        User user = currentUser(session);
        Patient patient = patientService.findByUserId(user.getUserId());
        model.addAttribute("appointments", appointmentService.forPatient(patient.getPatientId()));
        return "patient/feedback";
    }

    @PostMapping("/feedback")
    public String submitFeedback(@RequestParam Integer appointmentId, @RequestParam Integer rating,
                                  @RequestParam(required = false) String review,
                                  HttpSession session, Model model) throws DatabaseException {
        User user = currentUser(session);
        Patient patient = patientService.findByUserId(user.getUserId());
        Feedback feedback = new Feedback();
        feedback.setAppointmentId(appointmentId);
        feedback.setRating(rating);
        feedback.setReview(review);
        String error = feedbackService.submitFeedback(patient.getPatientId(), feedback);
        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("appointments", appointmentService.forPatient(patient.getPatientId()));
            return "patient/feedback";
        }
        return "redirect:/patient/feedback?submitted=1";
    }
}
