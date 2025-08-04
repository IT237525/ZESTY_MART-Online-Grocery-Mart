package dao;

import model.Contact;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO implements BaseDAO<Contact> {

    @Override
    public boolean insert(Contact contact) throws SQLException {
        String sql = "INSERT INTO Contact (UserID, Name, Phone, Subject, Message, Reply) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setObject(1, contact.getUserID(), Types.INTEGER);
            stmt.setString(2, contact.getName());
            stmt.setString(3, contact.getPhone());
            stmt.setString(4, contact.getSubject());
            stmt.setString(5, contact.getMessage());
            stmt.setString(6, contact.getReply());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        contact.setContactID(rs.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean update(Contact contact) throws SQLException {
        String sql = "UPDATE Contact SET UserID = ?, Name = ?, Phone = ?, Subject = ?, Message = ?, Reply = ? WHERE ContactID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setObject(1, contact.getUserID(), Types.INTEGER);
            stmt.setString(2, contact.getName());
            stmt.setString(3, contact.getPhone());
            stmt.setString(4, contact.getSubject());
            stmt.setString(5, contact.getMessage());
            stmt.setString(6, contact.getReply());
            stmt.setInt(7, contact.getContactID());
            
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM Contact WHERE ContactID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public Contact getById(int id) throws SQLException {
        String sql = "SELECT * FROM Contact WHERE ContactID = ?";
        Contact contact = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    contact = mapResultSetToContact(rs);
                }
            }
        }
        return contact;
    }

    @Override
    public List<Contact> getAll() throws SQLException {
        String sql = "SELECT * FROM Contact ORDER BY CreatedAt DESC";
        List<Contact> contacts = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                contacts.add(mapResultSetToContact(rs));
            }
        }
        return contacts;
    }

    @Override
    public List<Contact> search(String keyword) throws SQLException {
        String sql = "SELECT * FROM Contact WHERE Name LIKE ? OR Phone LIKE ? OR Subject LIKE ? OR Message LIKE ? ORDER BY CreatedAt DESC";
        List<Contact> contacts = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            for (int i = 1; i <= 4; i++) {
                stmt.setString(i, searchPattern);
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    contacts.add(mapResultSetToContact(rs));
                }
            }
        }
        return contacts;
    }

    // Additional methods specific to Contact
    public List<Contact> getByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM Contact WHERE UserID = ? ORDER BY CreatedAt DESC";
        List<Contact> contacts = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    contacts.add(mapResultSetToContact(rs));
                }
            }
        }
        return contacts;
    }

    public List<Contact> getByPhone(String phone) throws SQLException {
        String sql = "SELECT * FROM Contact WHERE Phone = ? ORDER BY CreatedAt DESC";
        List<Contact> contacts = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, phone);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    contacts.add(mapResultSetToContact(rs));
                }
            }
        }
        return contacts;
    }

    public boolean updateReply(int contactId, String reply) throws SQLException {
        String sql = "UPDATE Contact SET Reply = ? WHERE ContactID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, reply);
            stmt.setInt(2, contactId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    // Helper method to map ResultSet to Contact object
    private Contact mapResultSetToContact(ResultSet rs) throws SQLException {
        return new Contact(
                rs.getInt("ContactID"),
                rs.getObject("UserID", Integer.class),
                rs.getString("Name"),
                rs.getString("Phone"),
                rs.getString("Subject"),
                rs.getString("Message"),
                rs.getString("Reply"),
                rs.getTimestamp("CreatedAt")
        );
    }
}