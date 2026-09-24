package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Patient;
import com.echannel.model.User;
import com.echannel.service.PatientService;
import com.echannel.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.Optional;

/**
 * Central "Login / Authenticate" use case + patient self-registration.
 * On success, redirects to the correct dashboard for the user's role.
 */
@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private PatientService patientService;

    @GetMapping("/")
    public String home() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "auth/login";
    }

    @PostMapping("/login")
    public String doLogin(@RequestParam String username, @RequestParam String password,
                           HttpServletRequest request, Model model) {
        try {
            Optional<User> userOpt = userService.authenticate(username, password);
            if (userOpt.isEmpty()) {
                model.addAttribute("error", "Invalid username or password.");
                return "auth/login";
            }
            User user = userOpt.get();
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("loggedInUser", user);
            return "redirect:/home";
        } catch (DatabaseException e) {
            model.addAttribute("error", "System error: " + e.getMessage());
            return "auth/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "auth/register";
    }

    /** "Register Account" use case (Patient actor). */
    @PostMapping("/register")
    public String doRegister(@RequestParam String username, @RequestParam String password,
                              @RequestParam String fullName, @RequestParam String email,
                              @RequestParam String phone, @RequestParam(required = false) String nic,
                              @RequestParam(required = false) String address, Model model) {
        try {
            if (userService.usernameTaken(username)) {
                model.addAttribute("error", "That username is already taken.");
                return "auth/register";
            }
            User user = new User();
            user.setUsername(username);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);

            Patient patient = new Patient();
            patient.setNic(nic);
            patient.setAddress(address);

            patientService.registerPatientAccount(user, password, patient);
            model.addAttribute("success", "Account created! You can now log in.");
            return "auth/login";
        } catch (DatabaseException e) {
            model.addAttribute("error", "Could not register: " + e.getMessage());
            return "auth/register";
        }
    }

    private String dashboardFor(String role) {
        return switch (role) {
            case "PATIENT" -> "/patient/dashboard";
            case "DOCTOR" -> "/doctor/dashboard";
            case "RECEPTION" -> "/reception/dashboard";
            case "PHARMACIST" -> "/pharmacist/dashboard";
            case "OPERATIONS_MANAGER" -> "/operations/dashboard";
            case "ADMIN" -> "/admin/dashboard";
            default -> "/login";
        };
    }
}
