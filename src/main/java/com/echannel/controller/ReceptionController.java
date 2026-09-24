package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Patient;
import com.echannel.service.AppointmentService;
import com.echannel.service.DoctorService;
import com.echannel.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;

@Controller
@RequestMapping("/reception")
public class ReceptionController {

    @Autowired private AppointmentService appointmentService;
    @Autowired private PatientService patientService;
    @Autowired private DoctorService doctorService;

    @GetMapping("/dashboard")
    public String dashboard() {
        return "redirect:/portal";
    }

    /** Use Case: Register Walk-in Patient. */
    @GetMapping("/walkin")
    public String walkinPage() {
        return "reception/walkin";
    }

    @PostMapping("/walkin")
    public String registerWalkin(@RequestParam String fullName, @RequestParam String phone,
                                  @RequestParam(required = false) String nic,
                                  @RequestParam(required = false) String address, Model model)
            throws DatabaseException {
        Patient patient = new Patient();
        patient.setAddress(address);
        patientService.registerWalkIn(fullName, phone, nic, patient);
        model.addAttribute("success", "Patient " + fullName + " registered. Patient ID: " + patient.getPatientId());
        return "reception/walkin";
    }

    /** Use Case: View Daily Appointment List. */
    @GetMapping("/daily-list")
    public String dailyList(@RequestParam(required = false) String date, Model model) throws DatabaseException {
        LocalDate d = (date == null || date.isBlank()) ? LocalDate.now() : LocalDate.parse(date);
        model.addAttribute("appointments", appointmentService.forDate(d));
        model.addAttribute("selectedDate", d);
        return "reception/daily-list";
    }

    /** Update Booking Patient / verify payment status - simple status transitions. */
    @PostMapping("/update-status/{appointmentId}")
    public String updateStatus(@PathVariable Integer appointmentId, @RequestParam String status,
                                @RequestParam(required = false) String date) throws DatabaseException {
        appointmentService.updateStatus(appointmentId, status);
        return "redirect:/reception/daily-list" + (date != null ? "?date=" + date : "");
    }
}
