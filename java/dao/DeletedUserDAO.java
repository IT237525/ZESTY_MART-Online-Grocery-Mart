package dao;

import model.DeletedUser;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DeletedUserDAO implements BaseDAO<DeletedUser> {

    @Override
    public boolean insert(DeletedUser user) throws SQLException {
        String sql = "INSERT INTO DeletedUsers (UserID, FirstName, LastName, Gender, Phone, Address, Password, ProfileImage, ProfileImageType, DeletionDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, user.getUserId());
            stmt.setString(2, user.getFirstName());
            stmt.setString(3, user.getLastName());
            stmt.setString(4, user.getGender());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getAddress());
            stmt.setString(7, user.getPassword());
            stmt.setBytes(8, user.getProfileImage());
            stmt.setString(9, user.getProfileImageType());
            stmt.setTimestamp(10, user.getDeletionDate());
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean update(DeletedUser obj) throws SQLException {
        throw new UnsupportedOperationException("Deleted users are not updatable.");
    }

    @Override
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM DeletedUsers WHERE DeletedUserID=?";
        try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public DeletedUser getById(int id) throws SQLException {
        String sql = "SELECT * FROM DeletedUsers WHERE DeletedUserID=?";
        try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractDeletedUser(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<DeletedUser> getAll() throws SQLException {
        List<DeletedUser> list = new ArrayList<>();
        String sql = "SELECT * FROM DeletedUsers";
        try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(extractDeletedUser(rs));
            }
        }
        return list;
    }

    @Override
    public List<DeletedUser> search(String keyword) throws SQLException {
        List<DeletedUser> list = new ArrayList<>();
        String sql = "SELECT * FROM DeletedUsers WHERE FirstName LIKE ? OR LastName LIKE ? OR Phone LIKE ?";
        try (Connection conn = DatabaseUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            String likeKeyword = "%" + keyword + "%";
            stmt.setString(1, likeKeyword);
            stmt.setString(2, likeKeyword);
            stmt.setString(3, likeKeyword);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractDeletedUser(rs));
                }
            }
        }
        return list;
    }

    private DeletedUser extractDeletedUser(ResultSet rs) throws SQLException {
        return new DeletedUser(
            rs.getInt("DeletedUserID"),
            rs.getInt("UserID"),
            rs.getString("FirstName"),
            rs.getString("LastName"),
            rs.getString("Gender"),
            rs.getString("Phone"),
            rs.getString("Address"),
            rs.getString("Password"),
            rs.getBytes("ProfileImage"),
            rs.getString("ProfileImageType"),
            rs.getTimestamp("DeletionDate")
        );
    }
}
