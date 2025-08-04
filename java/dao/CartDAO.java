package dao;

import model.AddToCart;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO implements BaseDAO<AddToCart> {
	@Override
	public boolean insert(AddToCart item) throws SQLException {
	    String sql = "INSERT INTO AddToCart (UserID, ProductID, Quantity, UnitPrice, Total) VALUES (?, ?, ?, ?, ?)";
	    try (Connection conn = DatabaseUtil.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, item.getUserId());
	        pstmt.setInt(2, item.getProductId());
	        pstmt.setInt(3, item.getQuantity());
	        pstmt.setDouble(4, item.getUnitPrice());
	        pstmt.setDouble(5, item.getTotal());

	        int rowsAffected = pstmt.executeUpdate();
	        System.out.println("Rows affected: " + rowsAffected);  // Log rows affected

	        return rowsAffected > 0;
	    } catch (SQLException e) {
	        System.out.println("Error inserting into AddToCart: " + e.getMessage());
	        e.printStackTrace();
	        return false;
	    }
	}


    @Override
    public boolean update(AddToCart item) throws SQLException {
        String sql = "UPDATE AddToCart SET Quantity = ?, UnitPrice = ?, Total = ? WHERE UserID = ? AND ProductID = ?"; // Fixed typo
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, item.getQuantity());
            pstmt.setDouble(2, item.getUnitPrice());
            pstmt.setDouble(3, item.getTotal());
            pstmt.setInt(4, item.getUserId());
            pstmt.setInt(5, item.getProductId());
            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Updated cart item for UserID=" + item.getUserId() + ", ProductID=" + item.getProductId() + ", Rows affected=" + rowsAffected);
            return rowsAffected > 0;
        }
    }

    @Override
    public boolean delete(int id) throws SQLException {
        return false; // Not used
    }

    public boolean delete(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM AddToCart WHERE UserID = ? AND ProductID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            return pstmt.executeUpdate() > 0;
        }
    }

    @Override
    public AddToCart getById(int id) throws SQLException {
        return null; // Not used
    }

    public AddToCart getByUserAndProduct(int userId, int productId) throws SQLException {
        String sql = "SELECT c.UserID, c.ProductID, c.Quantity, c.UnitPrice, c.Total, p.Name AS productName, p.Image AS productImage " +
                     "FROM AddToCart c JOIN Product p ON c.ProductID = p.ProductID " +
                     "WHERE c.UserID = ? AND c.ProductID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                AddToCart item = new AddToCart(
                    rs.getInt("UserID"),
                    rs.getInt("ProductID"),
                    rs.getInt("Quantity"),
                    rs.getDouble("UnitPrice"),
                    rs.getDouble("Total")
                );
                item.setProductName(rs.getString("productName"));
                item.setProductImage(rs.getString("productImage"));
                return item;
            }
        }
        return null;
    }

    @Override
    public List<AddToCart> getAll() throws SQLException {
        return new ArrayList<>(); // Not used
    }

    public List<AddToCart> getByUserId(int userId) throws SQLException {
        List<AddToCart> items = new ArrayList<>();
        String sql = "SELECT c.UserID, c.ProductID, c.Quantity, c.UnitPrice, c.Total, p.Name AS productName, p.Image AS productImage " +
                     "FROM AddToCart c JOIN Product p ON c.ProductID = p.ProductID " +
                     "WHERE c.UserID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                AddToCart item = new AddToCart(
                    rs.getInt("UserID"),
                    rs.getInt("ProductID"),
                    rs.getInt("Quantity"),
                    rs.getDouble("UnitPrice"),
                    rs.getDouble("Total")
                );
                item.setProductName(rs.getString("productName"));
                item.setProductImage(rs.getString("productImage"));
                items.add(item);
            }
        }
        return items;
    }

    public boolean increaseQuantity(int userId, int productId, int amount) throws SQLException {
        String sql = "UPDATE AddToCart SET Quantity = Quantity + ?, Total = (Quantity + ?) * UnitPrice " +
                     "WHERE UserID = ? AND ProductID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, amount);
            pstmt.setInt(2, amount);
            pstmt.setInt(3, userId);
            pstmt.setInt(4, productId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean decreaseQuantity(int userId, int productId, int amount) throws SQLException {
        String sql = "UPDATE AddToCart SET Quantity = Quantity - ?, Total = (Quantity - ?) * UnitPrice " +
                     "WHERE UserID = ? AND ProductID = ? AND Quantity >= ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, amount);
            pstmt.setInt(2, amount);
            pstmt.setInt(3, userId);
            pstmt.setInt(4, productId);
            pstmt.setInt(5, amount);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                String checkSql = "SELECT Quantity FROM AddToCart WHERE UserID = ? AND ProductID = ?";
                try (PreparedStatement checkPstmt = conn.prepareStatement(checkSql)) {
                    checkPstmt.setInt(1, userId);
                    checkPstmt.setInt(2, productId);
                    ResultSet rs = checkPstmt.executeQuery();
                    if (rs.next() && rs.getInt("Quantity") <= 0) {
                        delete(userId, productId);
                    }
                }
                return true;
            }
            return false;
        }
    }

	@Override
	public List<AddToCart> search(String keyword) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}