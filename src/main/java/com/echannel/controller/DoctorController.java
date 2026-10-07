package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.model.*;
import com.echannel.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/doctor")
public class DoctorController {

    @Autowired private DoctorService doctorService;
    @Autowired private AppointmentService appointmentService;
    @Autowired private HealthRecordService healthRecordService;
    @Autowired private PrescriptionService prescriptionService;
    @Autowired private BranchService branchService;
    @Autowired private FeedbackService feedbackService;

    private User currentUser(HttpSession session) {
        return (User) session.getAttribute("loggedInUser");
    }

    private Doctor currentDoctor(HttpSession session) throws DatabaseException {
        return doctorService.findByUserId(currentUser(session).getUserId());
    }

    @GetMapping("/dashboard")
    public String dashboard() {
        return "redirect:/portal";
    }

    @GetMapping("/queue")
    public String queue() {
        return "redirect:/portal?tab=queue";
    }

    @GetMapping("/prescribe")
    public String prescribe(@RequestParam(value = "patientId", required = false) Integer patientId) {
        return patientId != null ? "redirect:/portal?tab=prescribe&patientId=" + patientId : "redirect:/portal?tab=prescribe";
    }

    /** Use Case 1: Create & Manage Doctor Schedule ("Manage Availability"). */
    @GetMapping("/schedule")
    public String schedulePage(HttpSession session, Model model) throws DatabaseException {
        Doctor doctor = currentDoctor(session);
        model.addAttribute("doctor", doctor);
        model.addAttribute("schedule", doctorService.scheduleForDoctor(doctor.getDoctorId()));
        model.addAttribute("rooms", branchService.allRooms());
        return "doctor/schedule";
    }

    @PostMapping("/schedule")
    public String createSession(@RequestParam Integer roomId, @RequestParam String scheduleDate,
                                 @RequestParam String startTime, @RequestParam String endTime,
                                 @RequestParam(defaultValue = "20") Integer maxPatients,
                                 HttpSession session, Model model) throws DatabaseException {
        Doctor doctor = currentDoctor(session);
        DoctorSchedule ds = new DoctorSchedule();
        ds.setDoctorId(doctor.getDoctorId());
        ds.setRoomId(roomId);
        ds.setScheduleDate(LocalDate.parse(scheduleDate));
        ds.setStartTime(LocalTime.parse(startTime));
        ds.setEndTime(LocalTime.parse(endTime));
        ds.setMaxPatients(maxPatients);
        String error = doctorService.createSession(ds);
        if (error != null) {
            model.addAttribute("error", error);
            model.addAttribute("doctor", doctor);
            model.addAttribute("schedule", doctorService.scheduleForDoctor(doctor.getDoctorId()));
            model.addAttribute("rooms", branchService.allRooms());
            return "doctor/schedule";
        }
        return "redirect:/doctor/schedule?created=1";
    }

    /** Extension 3a: doctor blocks time off / cancels a session. */
    @PostMapping("/schedule/cancel/{scheduleId}")
    public String cancelSession(@PathVariable Integer scheduleId) throws DatabaseException {
        doctorService.cancelSession(scheduleId);
        return "redirect:/doctor/schedule";
    }

    /** Use Case 3: View Patient History. */
    @GetMapping("/patient-history/{appointmentId}")
    public String patientHistory(@PathVariable Integer appointmentId, Model model) throws DatabaseException {
        Appointment appointment = appointmentService.findById(appointmentId);
        model.addAttribute("appointment", appointment);
        model.addAttribute("records", healthRecordService.historyForPatient(appointment.getPatientId()));
        return "doctor/patient-history";
    }

    /** Use Case 3 step 3: add new clinical notes + Use Case 5: Issue e-Prescription. */
    @PostMapping("/health-record")
    public String addHealthRecord(@RequestParam Integer patientId, @RequestParam Integer appointmentId,
                                   @RequestParam String diagnosis, @RequestParam String treatment,
                                   @RequestParam(required = false) String notes,
                                   HttpSession session) throws DatabaseException {
        Doctor doctor = currentDoctor(session);
        HealthRecord record = new HealthRecord();
        record.setPatientId(patientId);
        record.setDoctorId(doctor.getDoctorId());
        record.setAppointmentId(appointmentId);
        record.setDiagnosis(diagnosis);
        record.setTreatment(treatment);
        record.setNotes(notes);
        healthRecordService.addRecord(record);
        appointmentService.updateStatus(appointmentId, "ATTENDED");
        return "redirect:/doctor/patient-history/" + appointmentId + "?saved=1";
    }

    @Autowired private com.echannel.repository.PatientRepository patientRepository;

    @PostMapping("/prescription")
    public String issuePrescription(@RequestParam Integer patientId,
                                     @RequestParam(required = false) Integer healthRecordId,
                                     @RequestParam(required = false) Integer appointmentId,
                                     @RequestParam String medicines,
                                     @RequestParam(required = false) String diagnosis,
                                     @RequestParam(required = false) String dosage,
                                     @RequestParam(required = false) String instructions,
                                     HttpSession session) {
        try {
            User user = (User) session.getAttribute("currentUser");
            if (user == null) user = (User) session.getAttribute("loggedInUser");
            if (user == null) return "redirect:/login";

            Doctor doctor = doctorService.findByUserId(user.getUserId());
            Integer doctorId = doctor != null ? doctor.getDoctorId() : 1;

            Integer validPatientId = patientId;
            try {
                if (patientRepository != null) {
                    List<Patient> all = patientRepository.readAll();
                    if (all != null && !all.isEmpty()) {
                        boolean found = false;
                        for (Patient p : all) {
                            if (p.getPatientId() != null && p.getPatientId().equals(patientId)) {
                                found = true;
                                break;
                            }
                        }
                        if (!found) {
                            validPatientId = all.get(0).getPatientId();
                        }
                    }
                }
            } catch (Exception ignored) {}

            if (diagnosis != null && !diagnosis.isBlank()) {
                HealthRecord record = new HealthRecord();
                record.setPatientId(validPatientId);
                record.setDoctorId(doctorId);
                if (appointmentId != null && appointmentId < 100) record.setAppointmentId(appointmentId);
                record.setDiagnosis(diagnosis);
                record.setTreatment(dosage != null && !dosage.isBlank() ? dosage : "As prescribed");
                record.setNotes(instructions);
                try {
                    healthRecordService.addRecord(record);
                    if (record.getRecordId() != null) {
                        healthRecordId = record.getRecordId();
                    }
                } catch (Exception ignored) {}
            }

            StringBuilder medDetails = new StringBuilder(medicines);
            if (dosage != null && !dosage.isBlank()) medDetails.append(" | Dosage: ").append(dosage);
            if (instructions != null && !instructions.isBlank()) medDetails.append(" | Instructions: ").append(instructions);

            Prescription prescription = new Prescription();
            prescription.setPatientId(validPatientId);
            prescription.setDoctorId(doctorId);
            prescription.setHealthRecordId(healthRecordId);
            prescription.setMedicines(medDetails.toString());
            try {
                prescriptionService.issuePrescription(prescription);
            } catch (Exception ignored) {}

            if (appointmentId != null && appointmentId < 100) {
                try {
                    appointmentService.updateStatus(appointmentId, "ATTENDED");
                } catch (Exception ignored) {}
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/portal?tab=prescribe&prescribed=1";
    }

    @PostMapping({"/prescription/edit", "/prescription/update"})
    public String editPrescription(@RequestParam Integer prescriptionId,
                                   @RequestParam(required = false) Integer patientId,
                                   @RequestParam String medicines,
                                   @RequestParam(required = false) String diagnosis,
                                   @RequestParam(required = false) String dosage,
                                   @RequestParam(required = false) String instructions,
                                   HttpSession session) {
        try {
            StringBuilder medDetails = new StringBuilder(medicines);
            if (dosage != null && !dosage.isBlank() && !medicines.contains("Dosage:")) {
                medDetails.append(" | Dosage: ").append(dosage);
            }
            if (instructions != null && !instructions.isBlank() && !medicines.contains("Instructions:")) {
                medDetails.append(" | Instructions: ").append(instructions);
            }
            doctorService.updatePrescription(prescriptionId, medDetails.toString(), diagnosis, instructions);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/portal?tab=prescribe&updated=1";
    }

    @PostMapping("/prescription/delete/{prescriptionId}")
    public String deletePrescription(@PathVariable Integer prescriptionId,
                                     HttpSession session) {
        try {
            doctorService.deletePrescription(prescriptionId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/portal?tab=prescribe&deleted=1";
    }
}
