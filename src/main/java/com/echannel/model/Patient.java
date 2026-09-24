package com.echannel.model;

import java.time.LocalDate;

public class Patient {
    private Integer patientId;
    private Integer userId;     // nullable for walk-in patients with no login
    private String fullName;    // joined, or entered directly for walk-ins
    private String email;       // joined
    private String phone;       // joined
    private String nic;
    private LocalDate dob;
    private String address;

    public Patient() {}

    public Patient(Integer patientId, Integer userId, String nic, LocalDate dob, String address) {
        this.patientId = patientId;
        this.userId = userId;
        this.nic = nic;
        this.dob = dob;
        this.address = address;
    }

    public Integer getPatientId() { return patientId; }
    public void setPatientId(Integer patientId) { this.patientId = patientId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; }

    public LocalDate getDob() { return dob; }
    public void setDob(LocalDate dob) { this.dob = dob; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}
