package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.model.User;
import com.echannel.service.BranchService;
import com.echannel.service.DoctorService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controller for the shared common landing page (/home, /common-landing, /dashboard/common-landing).
 * Accessible to all authenticated user roles (Patient, Doctor, Receptionist, Admin, Pharmacist, Operation Manager).
 */
@Controller
public class HomeController {

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private BranchService branchService;

    private User currentUser(HttpSession session) {
        if (session == null) return null;
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            user = (User) session.getAttribute("loggedInUser");
        }
        return user;
    }

    @GetMapping({"/home", "/common-landing"})
    public String home(HttpSession session, Model model) {
        User user = currentUser(session);
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("currentUser", user);
        model.addAttribute("loggedInUser", user);
        model.addAttribute("pageTitle", "Central e-Channelling Portal");
        model.addAttribute("pageSubtitle", "Common Landing & System Hub");
        model.addAttribute("currentPage", "home");

        try {
            model.addAttribute("doctors", doctorService.allDoctors());
            model.addAttribute("branches", branchService.allBranches());
        } catch (DatabaseException e) {
            // Gracefully fallback if DB error occurs
        }

        return "common/home";
    }

    @GetMapping("/dashboard/common-landing")
    public String commonLanding(HttpSession session, Model model) {
        return home(session, model);
    }
}
