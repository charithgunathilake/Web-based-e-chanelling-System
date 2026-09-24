package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.User;
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
import java.util.Optional;

/**
 * POLYMORPHISM (dynamic / method overriding): implements the generic
 * Repository<T, ID> interface with User-specific behaviour, overriding
 * every method of the contract.
 */
@Repository
public class UserRepository implements com.echannel.repository.Repository<User, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<User> rowMapper = (rs, rowNum) -> {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setActive(rs.getBoolean("is_active"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) u.setCreatedAt(ts.toLocalDateTime());
        try {
            Timestamp ll = rs.getTimestamp("last_login");
            if (ll != null) u.setLastLogin(ll.toLocalDateTime());
        } catch (Exception ignored) {}
        return u;
    };

    @Override
    public void create(User u) throws DatabaseException {
        String sql = "INSERT INTO users (username, password, full_name, email, phone, role, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, u.getUsername());
                ps.setString(2, u.getPassword());
                ps.setString(3, u.getFullName());
                ps.setString(4, u.getEmail());
                ps.setString(5, u.getPhone());
                ps.setString(6, u.getRole());
                ps.setBoolean(7, u.isActive());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) {
                u.setUserId(keyHolder.getKey().intValue());
            }
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not create user: " + e.getMessage(), e);
        }
    }

    @Override
    public User readById(Integer id) throws DatabaseException {
        try {
            List<User> results = jdbcTemplate.query("SELECT * FROM users WHERE user_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read user by id: " + e.getMessage(), e);
        }
    }

    @Override
    public List<User> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query("SELECT * FROM users ORDER BY user_id", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read users: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(User u) throws DatabaseException {
        String sql = "UPDATE users SET full_name=?, email=?, phone=?, role=?, is_active=? WHERE user_id=?";
        try {
            jdbcTemplate.update(sql, u.getFullName(), u.getEmail(), u.getPhone(),
                    u.getRole(), u.isActive(), u.getUserId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update user: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE users SET is_active = 0 WHERE user_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not delete user: " + e.getMessage(), e);
        }
    }

    public Optional<User> findByUsername(String username) throws DatabaseException {
        try {
            List<User> results = jdbcTemplate.query("SELECT * FROM users WHERE username = ?", rowMapper, username);
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not find user by username: " + e.getMessage(), e);
        }
    }

    public void updatePassword(Integer userId, String newHashedPassword) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE users SET password = ? WHERE user_id = ?", newHashedPassword, userId);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not reset password: " + e.getMessage(), e);
        }
    }

    public void updateLastLogin(Integer userId) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE users SET last_login = GETDATE() WHERE user_id = ?", userId);
        } catch (DataAccessException e) {
            // log or ignore if non-critical
        }
    }
}
