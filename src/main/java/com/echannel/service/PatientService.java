package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Patient;
import com.echannel.model.User;
import com.echannel.repository.PatientRepository;
import com.echannel.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Handles Patient registration (self-service) and Reception walk-in patient registration.
 * NOTE (demo/viva mode): passwords are stored as PLAIN TEXT here on purpose - see
 * UserService.java for the same note and PasswordConfig.java for the BCrypt version
 * this was swapped out from.
 */
@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

    /** "Register Account" use case: patient signs up themselves with full login credentials. */
    public Patient registerPatientAccount(User user, String rawPassword, Patient patient) throws DatabaseException {
        user.setRole("PATIENT");
        user.setPassword(rawPassword);
        user.setActive(true);
        userRepository.create(user);

        patient.setUserId(user.getUserId());
        patientRepository.create(patient);
        return patient;
    }

    /**
     * "Register Walk-in Patient" use case (Reception Staff).
     * A lightweight user account is still created behind the scenes (with a
     * system-generated username/password) so the patient has one consistent
     * record even if they never log in themselves.
     */
    public Patient registerWalkIn(String fullName, String phone, String nic, Patient patient) throws DatabaseException {
        User user = new User();
        String generatedUsername = "walkin" + System.currentTimeMillis();
        user.setUsername(generatedUsername);
        user.setPassword("Temp@" + System.currentTimeMillis() % 100000);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setRole("PATIENT");
        user.setActive(true);
        userRepository.create(user);

        patient.setUserId(user.getUserId());
        patient.setNic(nic);
        patientRepository.create(patient);
        return patient;
    }

    public Patient findByUserId(Integer userId) throws DatabaseException {
        return patientRepository.findByUserId(userId);
    }

    public Patient findById(Integer patientId) throws DatabaseException {
        return patientRepository.readById(patientId);
    }

    public java.util.List<Patient> allPatients() throws DatabaseException {
        return patientRepository.readAll();
    }
}
