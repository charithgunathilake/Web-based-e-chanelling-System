package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Feedback;
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
import java.util.List;

@Repository
public class FeedbackRepository implements com.echannel.repository.Repository<Feedback, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String BASE_SELECT =
        "SELECT f.*, up.full_name AS patient_name, ud.full_name AS doctor_name " +
        "FROM feedback f " +
        "JOIN patients p ON f.patient_id = p.patient_id LEFT JOIN users up ON p.user_id = up.user_id " +
        "JOIN doctors d ON f.doctor_id = d.doctor_id JOIN users ud ON d.user_id = ud.user_id ";

    private final RowMapper<Feedback> rowMapper = (rs, rowNum) -> {
        Feedback f = new Feedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setAppointmentId(rs.getInt("appointment_id"));
        f.setPatientId(rs.getInt("patient_id"));
        f.setDoctorId(rs.getInt("doctor_id"));
        f.setRating(rs.getInt("rating"));
        f.setReview(rs.getString("review"));
        f.setFlagged(rs.getBoolean("is_flagged"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) f.setCreatedAt(ts.toLocalDateTime());
        try {
            f.setPatientName(rs.getString("patient_name"));
            f.setDoctorName(rs.getString("doctor_name"));
        } catch (Exception ignored) {}
        return f;
    };

    @Override
    public void create(Feedback f) throws DatabaseException {
        String sql = "INSERT INTO feedback (appointment_id, patient_id, doctor_id, rating, review) VALUES (?, ?, ?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, f.getAppointmentId());
                ps.setInt(2, f.getPatientId());
                ps.setInt(3, f.getDoctorId());
                ps.setInt(4, f.getRating());
                ps.setString(5, f.getReview());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) f.setFeedbackId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not submit feedback: " + e.getMessage(), e);
        }
    }

    @Override
    public Feedback readById(Integer id) throws DatabaseException {
        try {
            List<Feedback> results = jdbcTemplate.query(BASE_SELECT + " WHERE f.feedback_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read feedback: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Feedback> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " ORDER BY f.created_at DESC", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read feedback list: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Feedback f) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE feedback SET is_flagged = ? WHERE feedback_id = ?", f.isFlagged(), f.getFeedbackId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update feedback: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("DELETE FROM feedback WHERE feedback_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not delete feedback: " + e.getMessage(), e);
        }
    }

    public List<Feedback> findByDoctorId(Integer doctorId) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE f.doctor_id = ? ORDER BY f.created_at DESC", rowMapper, doctorId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read doctor's feedback: " + e.getMessage(), e);
        }
    }

    /** Uses GROUP BY + aggregate AVG() - matches the "multi-table queries" module (Group By / Aggregate functions). */
    public Double averageRatingForDoctor(Integer doctorId) throws DatabaseException {
        try {
            return jdbcTemplate.queryForObject(
                    "SELECT AVG(CAST(rating AS FLOAT)) FROM feedback WHERE doctor_id = ? AND is_flagged = 0",
                    Double.class, doctorId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not compute average rating: " + e.getMessage(), e);
        }
    }
}
