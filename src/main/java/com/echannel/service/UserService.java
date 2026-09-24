package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.User;
import com.echannel.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

/**
 * COMPOSITION: this service HAS-A UserRepository, rather than extending it,
 * keeping the layers loosely coupled.
 *
 * NOTE (demo/viva mode): passwords are stored and compared as PLAIN TEXT
 * here on purpose, so the actual value is visible when the table is queried
 * in SQL Server Management Studio. This is NOT safe for a real deployment -
 * see PasswordConfig.java for the BCrypt version this was swapped out from.
 */
@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    /** Login/Authenticate use case - updates last_login_timestamp in database upon success. */
    public Optional<User> authenticate(String username, String rawPassword) throws DatabaseException {
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isEmpty()) return Optional.empty();
        User user = userOpt.get();
        if (!user.isActive()) return Optional.empty();
        boolean matches = false;
        if (user.getPassword() != null) {
            if (user.getPassword().startsWith("$2a$") || user.getPassword().startsWith("$2b$") || user.getPassword().startsWith("$2y$")) {
                try {
                    matches = org.springframework.security.crypto.bcrypt.BCrypt.checkpw(rawPassword, user.getPassword());
                } catch (Exception ignored) {}
            }
            if (!matches) {
                matches = rawPassword.equals(user.getPassword());
            }
        }
        if (!matches) return Optional.empty();
        userRepository.updateLastLogin(user.getUserId());
        return Optional.of(user);
    }

    public User register(User user, String rawPassword) throws DatabaseException {
        user.setPassword(rawPassword);
        user.setActive(true);
        userRepository.create(user);
        return user;
    }

    public List<User> findAll() throws DatabaseException {
        return userRepository.readAll();
    }

    public User findById(Integer id) throws DatabaseException {
        return userRepository.readById(id);
    }

    public void updateRoleAndStatus(Integer userId, String role, boolean active) throws DatabaseException {
        User u = userRepository.readById(userId);
        if (u == null) throw new DatabaseException("User not found");
        u.setRole(role);
        u.setActive(active);
        userRepository.update(u);
    }

    public void resetPassword(Integer userId, String newRawPassword) throws DatabaseException {
        userRepository.updatePassword(userId, newRawPassword);
    }

    public boolean usernameTaken(String username) throws DatabaseException {
        return userRepository.findByUsername(username).isPresent();
    }
}
