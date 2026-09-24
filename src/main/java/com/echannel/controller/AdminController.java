package com.echannel.controller;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Branch;
import com.echannel.model.Room;
import com.echannel.model.User;
import com.echannel.service.BranchService;
import com.echannel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private UserService userService;
    @Autowired private BranchService branchService;

    @GetMapping("/dashboard")
    public String dashboard() {
        return "redirect:/portal";
    }

    /** Use Case: Manage User Roles. */
    @GetMapping("/users")
    public String users(Model model) throws DatabaseException {
        model.addAttribute("users", userService.findAll());
        return "admin/users";
    }

    @PostMapping("/users/update-role")
    public String updateRole(@RequestParam Integer userId, @RequestParam String role,
                              @RequestParam(defaultValue = "false") boolean active) throws DatabaseException {
        userService.updateRoleAndStatus(userId, role, active);
        return "redirect:/admin/users";
    }

    /** "Reset Password and perform Backups" use case (password reset portion). */
    @PostMapping("/users/reset-password")
    public String resetPassword(@RequestParam Integer userId, @RequestParam String newPassword) throws DatabaseException {
        userService.resetPassword(userId, newPassword);
        return "redirect:/admin/users?reset=1";
    }

    /** Use Case 4: Configure Branch Parameters (Hospital / Clinic Branch Management). */
    @GetMapping("/branches")
    public String branches(Model model) throws DatabaseException {
        model.addAttribute("branches", branchService.allBranches());
        model.addAttribute("rooms", branchService.allRooms());
        return "admin/branches";
    }

    @PostMapping("/branches/add")
    public String addBranch(@RequestParam String branchName, @RequestParam String address,
                             @RequestParam String phone) throws DatabaseException {
        branchService.addBranch(new Branch(null, branchName, address, phone));
        return "redirect:/admin/branches";
    }

    @PostMapping("/rooms/add")
    public String addRoom(@RequestParam Integer branchId, @RequestParam String roomNumber,
                           @RequestParam String department) throws DatabaseException {
        Room room = new Room();
        room.setBranchId(branchId);
        room.setRoomNumber(roomNumber);
        room.setDepartment(department);
        room.setStatus("ACTIVE");
        branchService.addRoom(room);
        return "redirect:/admin/branches";
    }

    /** Extension 3a in Use Case 4: "Delete Branch Parameter" -> deactivate a room instead of hard delete. */
    @PostMapping("/rooms/deactivate/{roomId}")
    public String deactivateRoom(@PathVariable Integer roomId) throws DatabaseException {
        branchService.deactivateRoom(roomId);
        return "redirect:/admin/branches";
    }
}
