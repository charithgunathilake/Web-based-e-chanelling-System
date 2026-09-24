package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Doctor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class DoctorRepository implements com.echannel.repository.Repository<Doctor, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String BASE_SELECT =
        "SELECT d.doctor_id, d.user_id, d.specialty, d.branch_id, u.full_name, u.email, u.phone, b.branch_name " +
        "FROM doctors d JOIN users u ON d.user_id = u.user_id JOIN branches b ON d.branch_id = b.branch_id ";

    private final RowMapper<Doctor> rowMapper = (rs, rowNum) -> {
        Doctor d = new Doctor();
        d.setDoctorId(rs.getInt("doctor_id"));
        d.setUserId(rs.getInt("user_id"));
        d.setSpecialty(rs.getString("specialty"));
        d.setBranchId(rs.getInt("branch_id"));
        d.setFullName(rs.getString("full_name"));
        d.setEmail(rs.getString("email"));
        d.setPhone(rs.getString("phone"));
        d.setBranchName(rs.getString("branch_name"));
        return d;
    };

    @Override
    public void create(Doctor d) throws DatabaseException {
        String sql = "INSERT INTO doctors (user_id, specialty, branch_id) VALUES (?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, d.getUserId());
                ps.setString(2, d.getSpecialty());
                ps.setInt(3, d.getBranchId());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) d.setDoctorId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not create doctor profile: " + e.getMessage(), e);
        }
    }

    @Override
    public Doctor readById(Integer id) throws DatabaseException {
        try {
            List<Doctor> results = jdbcTemplate.query(BASE_SELECT + " WHERE d.doctor_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read doctor: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Doctor> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " ORDER BY u.full_name", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read doctors: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Doctor d) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE doctors SET specialty=?, branch_id=? WHERE doctor_id=?",
                    d.getSpecialty(), d.getBranchId(), d.getDoctorId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update doctor: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("DELETE FROM doctors WHERE doctor_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not delete doctor: " + e.getMessage(), e);
        }
    }

    public Doctor findByUserId(Integer userId) throws DatabaseException {
        try {
            List<Doctor> results = jdbcTemplate.query(BASE_SELECT + " WHERE d.user_id = ?", rowMapper, userId);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not find doctor by user id: " + e.getMessage(), e);
        }
    }

    public List<Doctor> searchBySpecialty(String specialty) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE d.specialty LIKE ? ORDER BY u.full_name",
                    rowMapper, "%" + specialty + "%");
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not search doctors: " + e.getMessage(), e);
        }
    }
}
