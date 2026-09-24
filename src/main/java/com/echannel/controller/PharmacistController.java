package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.service.PrescriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/pharmacist")
public class PharmacistController {

    @Autowired private PrescriptionService prescriptionService;

    /** Use Case 5: View e-Prescription queue + Confirm Order Fulfilment (dispense). */
    @GetMapping("/dashboard")
    public String dashboard() {
        return "redirect:/portal";
    }

    @PostMapping("/dispense/{prescriptionId}")
    public String dispense(@PathVariable Integer prescriptionId) throws DatabaseException {
        prescriptionService.dispense(prescriptionId);
        return "redirect:/pharmacist/dashboard?dispensed=1";
    }
}
