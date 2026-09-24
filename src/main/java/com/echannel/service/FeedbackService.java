package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Appointment;
import com.echannel.model.Feedback;
import com.echannel.repository.AppointmentRepository;
import com.echannel.repository.FeedbackRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/** Handles Use Case 6: Submit & Manage Patient Feedback. */
@Service
public class FeedbackService {

    @Autowired
    private FeedbackRepository feedbackRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    /** Main scenario step 3 + extension 3a: only completed appointments belonging to the patient can be reviewed. */
    public String submitFeedback(Integer patientId, Feedback feedback) throws DatabaseException {
        Appointment appointment = appointmentRepository.readById(feedback.getAppointmentId());
        if (appointment == null || !appointment.getPatientId().equals(patientId)) {
            return "This appointment does not belong to you.";
        }
        if (!"ATTENDED".equals(appointment.getStatus())) {
            return "You can only leave feedback for a completed (attended) appointment.";
        }
        feedback.setPatientId(patientId);
        feedback.setDoctorId(appointment.getDoctorId());
        feedbackRepository.create(feedback);
        return null;
    }

    public List<Feedback> forDoctor(Integer doctorId) throws DatabaseException {
        return feedbackRepository.findByDoctorId(doctorId);
    }

    public List<Feedback> allFeedback() throws DatabaseException {
        return feedbackRepository.readAll();
    }

    public Double averageRating(Integer doctorId) throws DatabaseException {
        return feedbackRepository.averageRatingForDoctor(doctorId);
    }

    /** Extension 5a: Operations Manager flags/removes a review that violates guidelines. */
    public void flag(Integer feedbackId, boolean flagged) throws DatabaseException {
        Feedback f = new Feedback();
        f.setFeedbackId(feedbackId);
        f.setFlagged(flagged);
        feedbackRepository.update(f);
    }
}
