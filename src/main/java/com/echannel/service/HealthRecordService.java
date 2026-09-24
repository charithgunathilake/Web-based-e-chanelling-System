package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.HealthRecord;
import com.echannel.repository.HealthRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/** Handles Use Case 3: Add & Update Patient Health Records. */
@Service
public class HealthRecordService {

    @Autowired
    private HealthRecordRepository healthRecordRepository;

    public void addRecord(HealthRecord record) throws DatabaseException {
        healthRecordRepository.create(record);
    }

    public List<HealthRecord> historyForPatient(Integer patientId) throws DatabaseException {
        return healthRecordRepository.findByPatientId(patientId);
    }

    public void updateRecord(HealthRecord record) throws DatabaseException {
        healthRecordRepository.update(record);
    }
}
