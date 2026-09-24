package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Doctor;
import com.echannel.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.LinkedHashMap;
import java.util.Map;

@Controller
@RequestMapping("/operations")
public class OperationsController {

    @Autowired private BranchService branchService;
    @Autowired private DoctorService doctorService;
    @Autowired private FeedbackService feedbackService;
    @Autowired private AppointmentService appointmentService;

    /** Use Case: Monitor Room Usage + Generate Operational / Analytics Reports. */
    @GetMapping("/dashboard")
    public String dashboard() {
        return "redirect:/portal";
    }

    /** Extension 5a: flag/unflag a review that violates content guidelines. */
    @PostMapping("/feedback/flag/{feedbackId}")
    public String flagFeedback(@org.springframework.web.bind.annotation.PathVariable Integer feedbackId,
                                @RequestParam boolean flagged) throws DatabaseException {
        feedbackService.flag(feedbackId, flagged);
        return "redirect:/operations/dashboard";
    }
}
