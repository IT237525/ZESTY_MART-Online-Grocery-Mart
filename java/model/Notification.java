package model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private int userId;
    private String subject;
    private String message;
    private Timestamp createdAt;
    private boolean isRead;
    private boolean isDeletedByUser;

    // Constructors
    public Notification() {}

    public Notification(int userId, String subject, String message) {
        this.userId = userId;
        this.subject = subject;
        this.message = message;
    }

    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }

    public boolean isDeletedByUser() {
        return isDeletedByUser;
    }

    public void setDeletedByUser(boolean isDeletedByUser) {
        this.isDeletedByUser = isDeletedByUser;
        
}
    
}
