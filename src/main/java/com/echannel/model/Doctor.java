package com.echannel.model;

public class Doctor {
    private Integer doctorId;
    private Integer userId;
    private String fullName;   // joined from users table
    private String email;      // joined
    private String phone;      // joined
    private String specialty;
    private Integer branchId;
    private String branchName; // joined

    public Doctor() {}

    public Doctor(Integer doctorId, Integer userId, String specialty, Integer branchId) {
        this.doctorId = doctorId;
        this.userId = userId;
        this.specialty = specialty;
        this.branchId = branchId;
    }

    public Integer getDoctorId() { return doctorId; }
    public void setDoctorId(Integer doctorId) { this.doctorId = doctorId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getSpecialty() { return specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }

    public Integer getBranchId() { return branchId; }
    public void setBranchId(Integer branchId) { this.branchId = branchId; }

    public String getBranchName() { return branchName; }
    public void setBranchName(String branchName) { this.branchName = branchName; }
}
