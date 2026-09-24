package com.echannel.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class DoctorSchedule {
    private Integer scheduleId;
    private Integer doctorId;
    private String doctorName;   // joined
    private String specialty;    // joined
    private Integer roomId;
    private String roomNumber;   // joined
    private LocalDate scheduleDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private Integer maxPatients;
    private String status;       // AVAILABLE, FULL, CANCELLED

    public DoctorSchedule() {}

    public DoctorSchedule(Integer scheduleId, Integer doctorId, Integer roomId, LocalDate scheduleDate,
                           LocalTime startTime, LocalTime endTime, Integer maxPatients, String status) {
        this.scheduleId = scheduleId;
        this.doctorId = doctorId;
        this.roomId = roomId;
        this.scheduleDate = scheduleDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.maxPatients = maxPatients;
        this.status = status;
    }

    public Integer getScheduleId() { return scheduleId; }
    public void setScheduleId(Integer scheduleId) { this.scheduleId = scheduleId; }

    public Integer getDoctorId() { return doctorId; }
    public void setDoctorId(Integer doctorId) { this.doctorId = doctorId; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getSpecialty() { return specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }

    public Integer getRoomId() { return roomId; }
    public void setRoomId(Integer roomId) { this.roomId = roomId; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public LocalDate getScheduleDate() { return scheduleDate; }
    public void setScheduleDate(LocalDate scheduleDate) { this.scheduleDate = scheduleDate; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

    public Integer getMaxPatients() { return maxPatients; }
    public void setMaxPatients(Integer maxPatients) { this.maxPatients = maxPatients; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
