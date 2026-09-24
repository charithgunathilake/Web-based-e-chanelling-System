package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.HealthRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.List;

@Repository
public class HealthRecordRepository implements com.echannel.repository.Repository<HealthRecord, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String BASE_SELECT =
        "SELECT hr.*, up.full_name AS patient_name, ud.full_name AS doctor_name " +
        "FROM health_records hr " +
        "JOIN patients p ON hr.patient_id = p.patient_id LEFT JOIN users up ON p.user_id = up.user_id " +
        "JOIN doctors d ON hr.doctor_id = d.doctor_id JOIN users ud ON d.user_id = ud.user_id ";

    private final RowMapper<HealthRecord> rowMapper = (rs, rowNum) -> {
        HealthRecord h = new HealthRecord();
        h.setRecordId(rs.getInt("record_id"));
        h.setPatientId(rs.getInt("patient_id"));
        h.setDoctorId(rs.getInt("doctor_id"));
        int appId = rs.getInt("appointment_id");
        h.setAppointmentId(rs.wasNull() ? null : appId);
        h.setDiagnosis(rs.getString("diagnosis"));
        h.setTreatment(rs.getString("treatment"));
        h.setNotes(rs.getString("notes"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) h.setCreatedAt(ts.toLocalDateTime());
        try {
            h.setPatientName(rs.getString("patient_name"));
            h.setDoctorName(rs.getString("doctor_name"));
        } catch (Exception ignored) {}
        return h;
    };

    @Override
    public void create(HealthRecord h) throws DatabaseException {
        String sql = "INSERT INTO health_records (patient_id, doctor_id, appointment_id, diagnosis, treatment, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, h.getPatientId());
                ps.setInt(2, h.getDoctorId());
                if (h.getAppointmentId() != null) ps.setInt(3, h.getAppointmentId()); else ps.setNull(3, Types.INTEGER);
                ps.setString(4, h.getDiagnosis());
                ps.setString(5, h.getTreatment());
                ps.setString(6, h.getNotes());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) h.setRecordId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not create health record: " + e.getMessage(), e);
        }
    }

    @Override
    public HealthRecord readById(Integer id) throws DatabaseException {
        try {
            List<HealthRecord> results = jdbcTemplate.query(BASE_SELECT + " WHERE hr.record_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read health record: " + e.getMessage(), e);
        }
    }

    @Override
    public List<HealthRecord> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " ORDER BY hr.created_at DESC", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read health records: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(HealthRecord h) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE health_records SET diagnosis=?, treatment=?, notes=? WHERE record_id=?",
                    h.getDiagnosis(), h.getTreatment(), h.getNotes(), h.getRecordId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update health record: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("DELETE FROM health_records WHERE record_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not delete health record: " + e.getMessage(), e);
        }
    }

    public List<HealthRecord> findByPatientId(Integer patientId) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE hr.patient_id = ? ORDER BY hr.created_at DESC",
                    rowMapper, patientId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read patient's health history: " + e.getMessage(), e);
        }
    }
}
