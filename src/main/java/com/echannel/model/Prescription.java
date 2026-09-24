package com.echannel.model;

import java.time.LocalDateTime;

public class Prescription {
    private Integer prescriptionId;
    private Integer healthRecordId;
    private Integer patientId;
    private String patientName;   // joined
    private Integer doctorId;
    private String doctorName;    // joined
    private String medicines;
    private String status;        // PENDING, FULFILLED
    private LocalDateTime issuedAt;
    private LocalDateTime fulfilledAt;

    public Prescription() {}

    public Prescription(Integer prescriptionId, Integer healthRecordId, Integer patientId,
                         Integer doctorId, String medicines, String status) {
        this.prescriptionId = prescriptionId;
        this.healthRecordId = healthRecordId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.medicines = medicines;
        this.status = status;
    }

    public Integer getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(Integer prescriptionId) { this.prescriptionId = prescriptionId; }

    public Integer getHealthRecordId() { return healthRecordId; }
    public void setHealthRecordId(Integer healthRecordId) { this.healthRecordId = healthRecordId; }

    public Integer getPatientId() { return patientId; }
    public void setPatientId(Integer patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public Integer getDoctorId() { return doctorId; }
    public void setDoctorId(Integer doctorId) { this.doctorId = doctorId; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getMedicines() { return medicines; }
    public void setMedicines(String medicines) { this.medicines = medicines; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getIssuedAt() { return issuedAt; }
    public void setIssuedAt(LocalDateTime issuedAt) { this.issuedAt = issuedAt; }

    public LocalDateTime getFulfilledAt() { return fulfilledAt; }
    public void setFulfilledAt(LocalDateTime fulfilledAt) { this.fulfilledAt = fulfilledAt; }
}
