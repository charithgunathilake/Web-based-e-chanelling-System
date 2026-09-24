package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Room;
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
public class RoomRepository implements com.echannel.repository.Repository<Room, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Room> rowMapper = (rs, rowNum) -> {
        Room r = new Room();
        r.setRoomId(rs.getInt("room_id"));
        r.setBranchId(rs.getInt("branch_id"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setDepartment(rs.getString("department"));
        r.setStatus(rs.getString("status"));
        try { r.setBranchName(rs.getString("branch_name")); } catch (Exception ignored) {}
        return r;
    };

    @Override
    public void create(Room r) throws DatabaseException {
        String sql = "INSERT INTO rooms (branch_id, room_number, department, status) VALUES (?, ?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, r.getBranchId());
                ps.setString(2, r.getRoomNumber());
                ps.setString(3, r.getDepartment());
                ps.setString(4, r.getStatus() == null ? "ACTIVE" : r.getStatus());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) r.setRoomId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not create room (room number might already exist in this branch): " + e.getMessage(), e);
        }
    }

    @Override
    public Room readById(Integer id) throws DatabaseException {
        try {
            List<Room> results = jdbcTemplate.query("SELECT * FROM rooms WHERE room_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read room: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Room> readAll() throws DatabaseException {
        String sql = "SELECT r.*, b.branch_name FROM rooms r JOIN branches b ON r.branch_id = b.branch_id ORDER BY r.room_id";
        try {
            return jdbcTemplate.query(sql, rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read rooms: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Room r) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE rooms SET room_number=?, department=?, status=? WHERE room_id=?",
                    r.getRoomNumber(), r.getDepartment(), r.getStatus(), r.getRoomId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update room: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        // Extension 3a from the use-case spec: deactivate instead of hard delete,
        // to preserve historical appointment records.
        try {
            jdbcTemplate.update("UPDATE rooms SET status = 'INACTIVE' WHERE room_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not deactivate room: " + e.getMessage(), e);
        }
    }
}
