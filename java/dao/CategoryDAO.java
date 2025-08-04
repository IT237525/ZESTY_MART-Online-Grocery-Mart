package dao;

import model.Category;
import utils.DatabaseUtil;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO implements BaseDAO<Category>  {

    @Override
    public boolean insert(Category category) throws SQLException {
        String sql = "INSERT INTO Category (Description, Image) VALUES (?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getDescription());
            stmt.setString(2, category.getImage());
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean update(Category category) throws SQLException {
        String sql = "UPDATE Category SET Description = ?, Image = ? WHERE CategoryID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getDescription());
            stmt.setString(2, category.getImage());
            stmt.setInt(3, category.getCategoryId());
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM Category WHERE CategoryID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public Category getById(int id) throws SQLException {
        String sql = "SELECT * FROM Category WHERE CategoryID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                        rs.getInt("CategoryID"),
                        rs.getString("Description"),
                        rs.getString("Image")
                    );
                }
                return null;
            }
        }
    }

    @Override
    public List<Category> getAll() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Category";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                categories.add(new Category(
                    rs.getInt("CategoryID"),
                    rs.getString("Description"),
                    rs.getString("Image")
                ));
            }
        }
        return categories;
    }

    @Override
    public List<Category> search(String keyword) throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Category WHERE Description LIKE ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    categories.add(new Category(
                        rs.getInt("CategoryID"),
                        rs.getString("Description"),
                        rs.getString("Image")
                    ));
                }
            }
        }
        return categories;
    }
}