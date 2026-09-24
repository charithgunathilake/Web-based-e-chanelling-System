package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Notification;
import com.echannel.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    public List<Notification> forUser(Integer userId) throws DatabaseException {
        return notificationRepository.findByUserId(userId);
    }

    public void markAllRead(Integer userId) throws DatabaseException {
        notificationRepository.markAllRead(userId);
    }
}
