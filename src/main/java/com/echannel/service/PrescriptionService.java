package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Prescription;
import com.echannel.repository.PrescriptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/** Handles Use Case 5: Issue, View & Fulfil E-Prescriptions. */
@Service
public class PrescriptionService {

    @Autowired
    private PrescriptionRepository prescriptionRepository;

    /** Doctor issues an e-prescription from the consultation record. */
    public void issuePrescription(Prescription prescription) throws DatabaseException {
        prescriptionRepository.create(prescription);
    }

    public List<Prescription> forPatient(Integer patientId) throws DatabaseException {
        return prescriptionRepository.findByPatientId(patientId);
    }

    /** Pharmacist's queue of prescriptions still waiting to be dispensed. */
    public List<Prescription> pendingQueue() throws DatabaseException {
        return prescriptionRepository.findPending();
    }

    /** Pharmacist marks a prescription fulfilled - calls the sp_fulfil_prescription stored procedure. */
    public void dispense(Integer prescriptionId) throws DatabaseException {
        prescriptionRepository.fulfil(prescriptionId);
    }
}
