package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.DoctorSchedule;
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
import java.sql.Time;
import java.util.List;

@Repository
public class DoctorScheduleRepository implements com.echannel.repository.Repository<DoctorSchedule, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String BASE_SELECT =
        "SELECT ds.*, u.full_name AS doctor_name, d.specialty, r.room_number " +
        "FROM doctor_schedule ds " +
        "JOIN doctors d ON ds.doctor_id = d.doctor_id " +
        "JOIN users u ON d.user_id = u.user_id " +
        "JOIN rooms r ON ds.room_id = r.room_id ";

    private final RowMapper<DoctorSchedule> rowMapper = (rs, rowNum) -> {
        DoctorSchedule s = new DoctorSchedule();
        s.setScheduleId(rs.getInt("schedule_id"));
        s.setDoctorId(rs.getInt("doctor_id"));
        s.setRoomId(rs.getInt("room_id"));
        s.setScheduleDate(rs.getDate("schedule_date").toLocalDate());
        s.setStartTime(rs.getTime("start_time").toLocalTime());
        s.setEndTime(rs.getTime("end_time").toLocalTime());
        s.setMaxPatients(rs.getInt("max_patients"));
        s.setStatus(rs.getString("status"));
        try {
            s.setDoctorName(rs.getString("doctor_name"));
            s.setSpecialty(rs.getString("specialty"));
            s.setRoomNumber(rs.getString("room_number"));
        } catch (Exception ignored) {}
        return s;
    };

    @Override
    public void create(DoctorSchedule s) throws DatabaseException {
        String sql = "INSERT INTO doctor_schedule (doctor_id, room_id, schedule_date, start_time, end_time, max_patients, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, s.getDoctorId());
                ps.setInt(2, s.getRoomId());
                ps.setDate(3, Date.valueOf(s.getScheduleDate()));
                ps.setTime(4, Time.valueOf(s.getStartTime()));
                ps.setTime(5, Time.valueOf(s.getEndTime()));
                ps.setInt(6, s.getMaxPatients() == null ? 20 : s.getMaxPatients());
                ps.setString(7, s.getStatus() == null ? "AVAILABLE" : s.getStatus());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) s.setScheduleId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not create schedule session: " + e.getMessage(), e);
        }
    }

    @Override
    public DoctorSchedule readById(Integer id) throws DatabaseException {
        try {
            List<DoctorSchedule> results = jdbcTemplate.query(BASE_SELECT + " WHERE ds.schedule_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read schedule: " + e.getMessage(), e);
        }
    }

    @Override
    public List<DoctorSchedule> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " ORDER BY ds.schedule_date, ds.start_time", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read schedules: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(DoctorSchedule s) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE doctor_schedule SET room_id=?, schedule_date=?, start_time=?, end_time=?, max_patients=?, status=? WHERE schedule_id=?",
                    s.getRoomId(), Date.valueOf(s.getScheduleDate()), Time.valueOf(s.getStartTime()),
                    Time.valueOf(s.getEndTime()), s.getMaxPatients(), s.getStatus(), s.getScheduleId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update schedule: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE doctor_schedule SET status = 'CANCELLED' WHERE schedule_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not cancel schedule: " + e.getMessage(), e);
        }
    }

    public List<DoctorSchedule> findByDoctorId(Integer doctorId) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT + " WHERE ds.doctor_id = ? ORDER BY ds.schedule_date, ds.start_time",
                    rowMapper, doctorId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read doctor's schedules: " + e.getMessage(), e);
        }
    }

    /** Only sessions that are still AVAILABLE and today or in the future - used by patient search/booking. */
    public List<DoctorSchedule> findBookableByDoctorId(Integer doctorId) throws DatabaseException {
        try {
            return jdbcTemplate.query(BASE_SELECT +
                    " WHERE ds.doctor_id = ? AND ds.status = 'AVAILABLE' AND ds.schedule_date >= CAST(GETDATE() AS DATE) " +
                    " ORDER BY ds.schedule_date, ds.start_time", rowMapper, doctorId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read bookable schedules: " + e.getMessage(), e);
        }
    }

    /** Checks whether the doctor or the room already has an overlapping session (use-case step 4). */
    public boolean hasConflict(Integer doctorId, Integer roomId, java.time.LocalDate date,
                                java.time.LocalTime start, java.time.LocalTime end) throws DatabaseException {
        String sql = "SELECT COUNT(*) FROM doctor_schedule WHERE schedule_date = ? AND status <> 'CANCELLED' " +
                     "AND (doctor_id = ? OR room_id = ?) AND (start_time < ? AND end_time > ?)";
        try {
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class,
                    Date.valueOf(date), doctorId, roomId, Time.valueOf(end), Time.valueOf(start));
            return count != null && count > 0;
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not check schedule conflicts: " + e.getMessage(), e);
        }
    }
}
