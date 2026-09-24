package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Appointment;
import com.echannel.model.DoctorSchedule;
import com.echannel.repository.AppointmentRepository;
import com.echannel.repository.DoctorScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;

/** Handles Use Case 2: Search Doctors & Book Appointment (booking / reschedule / cancel / attendance). */
@Service
public class AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private DoctorScheduleRepository scheduleRepository;

    /**
     * Main scenario steps 3-5 + extension 4a: re-checks the slot is still
     * AVAILABLE right before confirming, generates the next token number,
     * and creates the appointment.
     */
    public String bookAppointment(Integer patientId, Integer scheduleId) throws DatabaseException {
        DoctorSchedule schedule = scheduleRepository.readById(scheduleId);
        if (schedule == null || !"AVAILABLE".equals(schedule.getStatus())) {
            return "This slot is no longer available. Please choose another slot.";
        }
        int nextToken = appointmentRepository.nextTokenNumber(scheduleId);
        if (nextToken > schedule.getMaxPatients()) {
            return "This session is already fully booked. Please choose another slot.";
        }
        Appointment appointment = new Appointment();
        appointment.setPatientId(patientId);
        appointment.setScheduleId(scheduleId);
        appointment.setTokenNo(nextToken);
        appointment.setStatus("BOOKED");
        appointmentRepository.create(appointment);
        return null; // success
    }

    public List<Appointment> forPatient(Integer patientId) throws DatabaseException {
        return appointmentRepository.findByPatientId(patientId);
    }

    public List<Appointment> forDoctor(Integer doctorId) throws DatabaseException {
        return appointmentRepository.findByDoctorId(doctorId);
    }

    public List<Appointment> forDate(LocalDate date) throws DatabaseException {
        return appointmentRepository.findByDate(date);
    }

    public List<Appointment> allAppointments() throws DatabaseException {
        return appointmentRepository.readAll();
    }

    public Appointment findById(Integer id) throws DatabaseException {
        return appointmentRepository.readById(id);
    }

    /** Reschedule / cancel, or reception marking attended / no-show (extensions 3a and 5a). */
    public void updateStatus(Integer appointmentId, String newStatus) throws DatabaseException {
        Appointment a = new Appointment();
        a.setAppointmentId(appointmentId);
        a.setStatus(newStatus);
        appointmentRepository.update(a);
    }
}
