package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.service.PrescriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping({"/pharmacist", "/pharmacy"})
public class PharmacistController {

    @Autowired private PrescriptionService prescriptionService;

    /** Use Case 5: View e-Prescription queue + Confirm Order Fulfilment (dispense). */
    @GetMapping({"/dashboard", "/queue", ""})
    public String dashboard() {
        return "redirect:/portal?tab=pharmacy";
    }

    @PostMapping({"/dispense/{prescriptionId}", "/dispense"})
    public String dispense(@PathVariable(required = false) Integer prescriptionId,
                           @RequestParam(required = false) Integer id,
                           @RequestParam(required = false) String pharmacyName) throws DatabaseException {
        Integer rxId = prescriptionId != null ? prescriptionId : id;
        if (rxId != null) {
            prescriptionService.dispense(rxId, pharmacyName);
        }
        return "redirect:/portal?tab=pharmacy&dispensed=1";
    }

    @PostMapping("/assign-pharmacy")
    public String assignPharmacy(@RequestParam Integer prescriptionId,
                                 @RequestParam String pharmacyName) throws DatabaseException {
        prescriptionService.updatePharmacy(prescriptionId, pharmacyName);
        return "redirect:/portal?tab=pharmacy&updated=1";
    }
}
