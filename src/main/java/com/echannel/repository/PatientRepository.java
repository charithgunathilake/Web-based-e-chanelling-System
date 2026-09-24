package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Patient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Types;
import java.util.List;

@Repository
public class PatientRepository implements com.echannel.repository.Repository<Patient, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String BASE_SELECT =
        "SELECT p.*, u.full_name, u.email, u.phone FROM patients p LEFT JOIN users u ON p.user_id = u.user_id ";

    private final RowMapper<Patient> rowMapper = (rs, rowNum) -> {
        Patient p = new Patient();
        p.setPatientId(rs.getInt("patient_id"));
        int uid = rs.getInt("user_id");
        p.setUserId(rs.wasNull() ? null : uid);
        p.setNic(rs.getString("nic"));
        if (rs.getDate("dob") != null) p.setDob(rs.getDate("dob").toLocalDate());
        p.setAddress(rs.getString("address"));
        p.setFullName(rs.getString("full_name"));
        p.setEmail(rs.getString("email"));
        p.setPhone(rs.getString("phone"));
        return p;
    };

    @Override
    public void create(Patient p) throws DatabaseException {
        String sql = "INSERT INTO patients (user_id, nic, dob, address) VALUES (?, ?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                if (p.getUserId() != null) ps.setInt(1, p.getUserId()); else ps.setNull(1, Types.INTEGER);
                ps.setString(2, p.getNic());
                if (p.getDob() != null) ps.setDate(3, Date.valueOf(p.getDob())); else ps.setNull(3, Types.DATE);
                ps.setString(4, p.getAddress());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) p.setPatientId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not create patient profile: " + e.getMessage(), e);
        }
    }

    @Override
    public Patient readById(Integer id) throws DatabaseException {
        try {
            List<Patient> results = jdbcTemplate.query(BASE_SELECT + " WHERE p.patient_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read patient: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Patient> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " ORDER BY p.patient_id DESC", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read patients: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Patient p) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE patients SET nic=?, dob=?, address=? WHERE patient_id=?",
                    p.getNic(), p.getDob() == null ? null : Date.valueOf(p.getDob()), p.getAddress(), p.getPatientId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update patient: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("DELETE FROM patients WHERE patient_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not delete patient: " + e.getMessage(), e);
        }
    }

    public Patient findByUserId(Integer userId) throws DatabaseException {
        try {
            List<Patient> results = jdbcTemplate.query(BASE_SELECT + " WHERE p.user_id = ?", rowMapper, userId);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not find patient by user id: " + e.getMessage(), e);
        }
    }
}
