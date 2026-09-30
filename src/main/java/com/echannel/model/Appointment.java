package com.echannel.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class Appointment {
    private Integer appointmentId;
    private Integer patientId;
    private String patientName;   // joined
    private String patientNic;    // joined
    private String patientPhone;  // joined
    private String ageGender;     // computed (e.g. 41 / Male)
    private Integer scheduleId;
    private Integer doctorId;     // joined
    private String doctorName;    // joined
    private String specialty;     // joined
    private String roomNumber;    // joined
    private LocalDate scheduleDate; // joined
    private LocalTime startTime;    // joined
    private Integer tokenNo;
    private String status;        // BOOKED, WAITING, IN_CONSULTATION, ATTENDED, CANCELLED, NO_SHOW
    private LocalDateTime bookedAt;

    public Appointment() {}

    public Appointment(Integer appointmentId, Integer patientId, Integer scheduleId, Integer tokenNo, String status) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.scheduleId = scheduleId;
        this.tokenNo = tokenNo;
        this.status = status;
    }

    public Integer getAppointmentId() { return appointmentId; }
    public void setAppointmentId(Integer appointmentId) { this.appointmentId = appointmentId; }

    public Integer getPatientId() { return patientId; }
    public void setPatientId(Integer patientId) { this.patientId = patientId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getPatientNic() { return patientNic; }
    public void setPatientNic(String patientNic) { this.patientNic = patientNic; }

    public String getPatientPhone() { return patientPhone; }
    public void setPatientPhone(String patientPhone) { this.patientPhone = patientPhone; }

    public String getAgeGender() { return ageGender; }
    public void setAgeGender(String ageGender) { this.ageGender = ageGender; }

    public Integer getScheduleId() { return scheduleId; }
    public void setScheduleId(Integer scheduleId) { this.scheduleId = scheduleId; }

    public Integer getDoctorId() { return doctorId; }
    public void setDoctorId(Integer doctorId) { this.doctorId = doctorId; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getSpecialty() { return specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public LocalDate getScheduleDate() { return scheduleDate; }
    public void setScheduleDate(LocalDate scheduleDate) { this.scheduleDate = scheduleDate; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public Integer getTokenNo() { return tokenNo; }
    public void setTokenNo(Integer tokenNo) { this.tokenNo = tokenNo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getBookedAt() { return bookedAt; }
    public void setBookedAt(LocalDateTime bookedAt) { this.bookedAt = bookedAt; }
}
