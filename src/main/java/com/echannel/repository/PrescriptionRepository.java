package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Prescription;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.List;

@Repository
public class PrescriptionRepository implements com.echannel.repository.Repository<Prescription, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private DataSource dataSource;

    private static final String BASE_SELECT =
        "SELECT pr.*, up.full_name AS patient_name, ud.full_name AS doctor_name " +
        "FROM prescriptions pr " +
        "JOIN patients p ON pr.patient_id = p.patient_id LEFT JOIN users up ON p.user_id = up.user_id " +
        "JOIN doctors d ON pr.doctor_id = d.doctor_id JOIN users ud ON d.user_id = ud.user_id ";

    private final RowMapper<Prescription> rowMapper = (rs, rowNum) -> {
        Prescription p = new Prescription();
        p.setPrescriptionId(rs.getInt("prescription_id"));
        int hrId = rs.getInt("health_record_id");
        p.setHealthRecordId(rs.wasNull() ? null : hrId);
        p.setPatientId(rs.getInt("patient_id"));
        p.setDoctorId(rs.getInt("doctor_id"));
        p.setMedicines(rs.getString("medicines"));
        p.setStatus(rs.getString("status"));
        Timestamp issued = rs.getTimestamp("issued_at");
        if (issued != null) p.setIssuedAt(issued.toLocalDateTime());
        Timestamp fulfilled = rs.getTimestamp("fulfilled_at");
        if (fulfilled != null) p.setFulfilledAt(fulfilled.toLocalDateTime());
        try {
            p.setPatientName(rs.getString("patient_name"));
            p.setDoctorName(rs.getString("doctor_name"));
        } catch (Exception ignored) {}
        return p;
    };

    @Override
    public void create(Prescription p) throws DatabaseException {
        String sql = "INSERT INTO prescriptions (health_record_id, patient_id, doctor_id, medicines, status) VALUES (?, ?, ?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                if (p.getHealthRecordId() != null) ps.setInt(1, p.getHealthRecordId()); else ps.setNull(1, Types.INTEGER);
                ps.setInt(2, p.getPatientId());
                ps.setInt(3, p.getDoctorId());
                ps.setString(4, p.getMedicines());
                ps.setString(5, "PENDING");
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) p.setPrescriptionId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not issue prescription: " + e.getMessage(), e);
        }
    }

    @Override
    public Prescription readById(Integer id) throws DatabaseException {
        try {
            List<Prescription> results = jdbcTemplate.query(BASE_SELECT + " WHERE pr.prescription_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read prescription: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Prescription> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " ORDER BY pr.issued_at DESC", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read prescriptions: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Prescription p) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE prescriptions SET medicines=?, status=? WHERE prescription_id=?",
                    p.getMedicines(), p.getStatus(), p.getPrescriptionId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update prescription: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("DELETE FROM prescriptions WHERE prescription_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not delete prescription: " + e.getMessage(), e);
        }
    }

    public List<Prescription> findByPatientId(Integer patientId) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE pr.patient_id = ? ORDER BY pr.issued_at DESC",
                    rowMapper, patientId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read patient's prescriptions: " + e.getMessage(), e);
        }
    }

    public List<Prescription> findPending() throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE pr.status = 'PENDING' ORDER BY pr.issued_at", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read pending prescriptions: " + e.getMessage(), e);
        }
    }

    /**
     * Dispenses ("fulfils") a prescription by CALLING the sp_fulfil_prescription
     * stored procedure in SQL Server, instead of running a plain UPDATE here.
     * This demonstrates "calling functions and stored procedures" from the app.
     */
    public void fulfil(Integer prescriptionId) throws DatabaseException {
        try {
            SimpleJdbcCall call = new SimpleJdbcCall(dataSource).withProcedureName("sp_fulfil_prescription");
            call.execute(java.util.Map.of("PrescriptionId", prescriptionId));
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not dispense prescription: " + e.getMessage(), e);
        }
    }
}
