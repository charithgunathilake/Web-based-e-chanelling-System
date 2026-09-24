package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Appointment;
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
public class AppointmentRepository implements com.echannel.repository.Repository<Appointment, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String BASE_SELECT =
        "SELECT a.*, up.full_name AS patient_name, ds.doctor_id, ud.full_name AS doctor_name, " +
        "d.specialty, r.room_number, ds.schedule_date, ds.start_time " +
        "FROM appointments a " +
        "JOIN patients p ON a.patient_id = p.patient_id " +
        "LEFT JOIN users up ON p.user_id = up.user_id " +
        "JOIN doctor_schedule ds ON a.schedule_id = ds.schedule_id " +
        "JOIN doctors d ON ds.doctor_id = d.doctor_id " +
        "JOIN users ud ON d.user_id = ud.user_id " +
        "JOIN rooms r ON ds.room_id = r.room_id ";

    private final RowMapper<Appointment> rowMapper = (rs, rowNum) -> {
        Appointment a = new Appointment();
        a.setAppointmentId(rs.getInt("appointment_id"));
        a.setPatientId(rs.getInt("patient_id"));
        a.setScheduleId(rs.getInt("schedule_id"));
        a.setTokenNo(rs.getInt("token_no"));
        a.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("booked_at");
        if (ts != null) a.setBookedAt(ts.toLocalDateTime());
        try {
            a.setPatientName(rs.getString("patient_name"));
            a.setDoctorId(rs.getInt("doctor_id"));
            a.setDoctorName(rs.getString("doctor_name"));
            a.setSpecialty(rs.getString("specialty"));
            a.setRoomNumber(rs.getString("room_number"));
            a.setScheduleDate(rs.getDate("schedule_date").toLocalDate());
            a.setStartTime(rs.getTime("start_time").toLocalTime());
        } catch (Exception ignored) {}
        return a;
    };

    @Override
    public void create(Appointment a) throws DatabaseException {
        String sql = "INSERT INTO appointments (patient_id, schedule_id, token_no, status) VALUES (?, ?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, a.getPatientId());
                ps.setInt(2, a.getScheduleId());
                ps.setInt(3, a.getTokenNo());
                ps.setString(4, a.getStatus() == null ? "BOOKED" : a.getStatus());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) a.setAppointmentId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not create appointment: " + e.getMessage(), e);
        }
    }

    @Override
    public Appointment readById(Integer id) throws DatabaseException {
        try {
            List<Appointment> results = jdbcTemplate.query(BASE_SELECT + " WHERE a.appointment_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read appointment: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Appointment> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " ORDER BY ds.schedule_date DESC, ds.start_time", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read appointments: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Appointment a) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE appointments SET status = ? WHERE appointment_id = ?",
                    a.getStatus(), a.getAppointmentId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update appointment: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE appointments SET status = 'CANCELLED' WHERE appointment_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not cancel appointment: " + e.getMessage(), e);
        }
    }

    public List<Appointment> findByPatientId(Integer patientId) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE a.patient_id = ? ORDER BY ds.schedule_date DESC",
                    rowMapper, patientId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read patient's appointments: " + e.getMessage(), e);
        }
    }

    public List<Appointment> findByDoctorId(Integer doctorId) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE ds.doctor_id = ? ORDER BY ds.schedule_date DESC",
                    rowMapper, doctorId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read doctor's appointments: " + e.getMessage(), e);
        }
    }

    public List<Appointment> findByDate(java.time.LocalDate date) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE ds.schedule_date = ? ORDER BY ds.start_time, a.token_no",
                    rowMapper, java.sql.Date.valueOf(date));
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read appointments for date: " + e.getMessage(), e);
        }
    }

    public int nextTokenNumber(Integer scheduleId) throws DatabaseException {
        try {
            Integer max = jdbcTemplate.queryForObject(
                    "SELECT ISNULL(MAX(token_no), 0) FROM appointments WHERE schedule_id = ? AND status <> 'CANCELLED'",
                    Integer.class, scheduleId);
            return (max == null ? 0 : max) + 1;
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not compute next token number: " + e.getMessage(), e);
        }
    }
}
