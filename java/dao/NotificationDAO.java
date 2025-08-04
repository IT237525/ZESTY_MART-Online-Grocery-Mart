package dao;

import model.Notification;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO implements BaseDAO<Notification> {

    @Override
    public boolean insert(Notification notification) throws SQLException {
        String sql = "INSERT INTO Notifications (UserID, Subject, Message) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notification.getUserId());
            stmt.setString(2, notification.getSubject());
            stmt.setString(3, notification.getMessage());
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean update(Notification notification) throws SQLException {
        String sql = "UPDATE Notifications SET Subject = ?, Message = ?, IsRead = ?, IsDeletedByUser = ? WHERE NotificationID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, notification.getSubject());
            stmt.setString(2, notification.getMessage());
            stmt.setBoolean(3, notification.isRead());
            stmt.setBoolean(4, notification.isDeletedByUser());
            stmt.setInt(5, notification.getNotificationId());
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM Notifications WHERE NotificationID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public Notification getById(int id) throws SQLException {
        String sql = "SELECT * FROM Notifications WHERE NotificationID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToNotification(rs);
            }
        }
        return null;
    }

    @Override
    public List<Notification> getAll() throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        }
        return notifications;
    }

    @Override
    public List<Notification> search(String keyword) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE Subject LIKE ? OR Message LIKE ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        }
        return notifications;
    }

    // Extra methods not part of BaseDAO

    public boolean markAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE Notifications SET IsRead = TRUE WHERE NotificationID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean markAsDeletedByUser(int notificationId) throws SQLException {
        String sql = "UPDATE Notifications SET IsDeletedByUser = TRUE WHERE NotificationID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, notificationId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean markAllAsRead(int userId) throws SQLException {
        String sql = "UPDATE Notifications SET IsRead = TRUE WHERE UserID = ? AND IsRead = FALSE AND IsDeletedByUser = FALSE";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public int getUnreadNotificationCount(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) AS UnreadCount FROM Notifications WHERE UserID = ? AND IsRead = FALSE AND IsDeletedByUser = FALSE";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("UnreadCount");
            }
        }
        return 0;
    }

    public List<Notification> getByUserId(int userId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        }
        return notifications;
    }

    public List<Notification> getActiveNotificationsByUser(int userId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserID = ? AND IsDeletedByUser = FALSE";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        }
        return notifications;
    }

    public List<Notification> getDeletedNotificationsByUser(int userId) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM Notifications WHERE UserID = ? AND IsDeletedByUser = TRUE";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        }
        return notifications;
    }

    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("NotificationID"));
        n.setUserId(rs.getInt("UserID"));
        n.setSubject(rs.getString("Subject"));
        n.setMessage(rs.getString("Message"));
        n.setCreatedAt(rs.getTimestamp("CreatedAt"));
        n.setRead(rs.getBoolean("IsRead"));
        n.setDeletedByUser(rs.getBoolean("IsDeletedByUser"));
        return n;
    }
}
