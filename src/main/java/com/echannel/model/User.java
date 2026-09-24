package com.echannel.model;

import java.time.LocalDateTime;

/**
 * Represents a login account for any actor in the system
 * (Patient, Doctor, Reception, Pharmacist, Operations Manager, Admin).
 *
 * ENCAPSULATION: all fields are private; access is only through the
 * public getters/setters below.
 */
public class User {

    private Integer userId;
    private String username;
    private String password;   // BCrypt hash
    private String fullName;
    private String email;
    private String phone;
    private String role;       // PATIENT, DOCTOR, RECEPTION, PHARMACIST, OPERATIONS_MANAGER, ADMIN
    private boolean active;
    private LocalDateTime createdAt;
    private LocalDateTime lastLogin;

    // Overloaded no-arg constructor (STATIC / COMPILE-TIME POLYMORPHISM: constructor overloading)
    public User() {
    }

    // Overloaded all-args constructor
    public User(Integer userId, String username, String password, String fullName,
                String email, String phone, String role, boolean active, LocalDateTime createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.active = active;
        this.createdAt = createdAt;
    }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) { this.lastLogin = lastLogin; }
}
