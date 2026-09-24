package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Branch;
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
public class BranchRepository implements com.echannel.repository.Repository<Branch, Integer> {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private final RowMapper<Branch> rowMapper = (rs, rowNum) -> new Branch(
            rs.getInt("branch_id"), rs.getString("branch_name"), rs.getString("address"), rs.getString("phone")
    );

    @Override
    public void create(Branch b) throws DatabaseException {
        String sql = "INSERT INTO branches (branch_name, address, phone) VALUES (?, ?, ?)";
        try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(con -> {
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, b.getBranchName());
                ps.setString(2, b.getAddress());
                ps.setString(3, b.getPhone());
                return ps;
            }, keyHolder);
            if (keyHolder.getKey() != null) b.setBranchId(keyHolder.getKey().intValue());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not create branch: " + e.getMessage(), e);
        }
    }

    @Override
    public Branch readById(Integer id) throws DatabaseException {
        try {
            List<Branch> results = jdbcTemplate.query("SELECT * FROM branches WHERE branch_id = ?", rowMapper, id);
            return results.isEmpty() ? null : results.get(0);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read branch: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Branch> readAll() throws DatabaseException {
        try {
            return jdbcTemplate.query("SELECT * FROM branches ORDER BY branch_id", rowMapper);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not read branches: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Branch b) throws DatabaseException {
        try {
            jdbcTemplate.update("UPDATE branches SET branch_name=?, address=?, phone=? WHERE branch_id=?",
                    b.getBranchName(), b.getAddress(), b.getPhone(), b.getBranchId());
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not update branch: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        try {
            jdbcTemplate.update("DELETE FROM branches WHERE branch_id = ?", id);
        } catch (DataAccessException e) {
            throw new DatabaseException("Could not delete branch: " + e.getMessage(), e);
        }
    }
}
