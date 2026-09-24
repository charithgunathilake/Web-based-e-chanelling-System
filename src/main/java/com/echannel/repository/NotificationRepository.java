package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import java.sql.Timestamp;
import java.util.List;

/** Simple read-mostly repository for the notifications table populated by trg_prescription_fulfilled. */
@Repository
public class NotificationRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Notification> rowMapper = (rs, rowNum) -> {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setUserId(rs.getInt("user_id"));
        n.setMessage(rs.getString("message"));
        n.setRead(rs.getBoolean("is_read"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) n.setCreatedAt(ts.toLocalDateTime());
        return n;
    };

    public List<Notification> findByUserId(Integer userId) throws DatabaseException {
        try {
            return jdbcTemplate.query(
                    "SELECT TOP 20 * FROM notifications WHERE user_id = ? ORDER BY created_at DESC",
                    rowMapper, userId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read notifications: " + e.getMessage(), e);
        }
    }

    public void markAllRead(Integer userId) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE notifications SET is_read = 1 WHERE user_id = ?", userId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update notifications: " + e.getMessage(), e);
        }
    }
}
