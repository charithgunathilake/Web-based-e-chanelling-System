package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Doctor;
import com.echannel.model.DoctorSchedule;
import com.echannel.repository.DoctorRepository;
import com.echannel.repository.DoctorScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/** Handles Use Case 1: Create & Manage Doctor Schedule, plus doctor lookup / search. */
@Service
public class DoctorService {

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private DoctorScheduleRepository scheduleRepository;

    public List<Doctor> allDoctors() throws DatabaseException {
        return doctorRepository.readAll();
    }

    public Doctor findByUserId(Integer userId) throws DatabaseException {
        return doctorRepository.findByUserId(userId);
    }

    /** Use Case 2 step 1: Patient searches for a specialist. */
    public List<Doctor> searchBySpecialty(String specialty) throws DatabaseException {
        if (specialty == null || specialty.isBlank()) return doctorRepository.readAll();
        return doctorRepository.searchBySpecialty(specialty);
    }

    public List<DoctorSchedule> scheduleForDoctor(Integer doctorId) throws DatabaseException {
        return scheduleRepository.findByDoctorId(doctorId);
    }

    public List<DoctorSchedule> bookableSlots(Integer doctorId) throws DatabaseException {
        return scheduleRepository.findBookableByDoctorId(doctorId);
    }

    /**
     * Use Case 1, main scenario steps 3-5 and extension 4a:
     * creates a new consultation session only if there is no conflict
     * for either the doctor or the room at that date/time.
     */
    public String createSession(DoctorSchedule session) throws DatabaseException {
        boolean conflict = scheduleRepository.hasConflict(
                session.getDoctorId(), session.getRoomId(), session.getScheduleDate(),
                session.getStartTime(), session.getEndTime());
        if (conflict) {
            return "This doctor or room is already booked for an overlapping time slot. Please choose a different time or room.";
        }
        scheduleRepository.create(session);
        return null; // null = success
    }

    /** Use Case 1, extension 3a: doctor blocks time off (leave) instead of creating a session. */
    public void cancelSession(Integer scheduleId) throws DatabaseException {
        scheduleRepository.delete(scheduleId);
    }
}
