package dao;

import model.AddToCart;
import model.Product;
import utils.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AddToCartDAO implements BaseDAO<AddToCart> {


    @Override
    public boolean insert(AddToCart cart) throws SQLException {
        String sql = "INSERT INTO AddToCart (UserID, ProductID, Quantity, UnitPrice, Total) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, cart.getUserId());
            ps.setInt(2, cart.getProductId());
            ps.setInt(3, cart.getQuantity());
            ps.setDouble(4, cart.getUnitPrice());
            ps.setDouble(5, cart.getTotal());

            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected by insert: " + rowsAffected); // Debug
            return rowsAffected > 0;
        }
    }


    @Override
    public boolean update(AddToCart cart) throws SQLException {
        String sql = "UPDATE AddToCart SET Quantity = ?, Total = ? WHERE UserID = ? AND ProductID = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cart.getQuantity());
            ps.setDouble(2, cart.getTotal());
            ps.setInt(3, cart.getUserId());
            ps.setInt(4, cart.getProductId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int id) throws SQLException {
        // Not used as we delete by UserID and ProductID
        return false;
    }

    public boolean delete(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM AddToCart WHERE UserID = ? AND ProductID = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public AddToCart getById(int id) throws SQLException {
        // Not used as we fetch by UserID and ProductID
        return null;
    }

    public AddToCart getByUserAndProduct(int userId, int productId) throws SQLException {
        String sql = "SELECT * FROM AddToCart WHERE UserID = ? AND ProductID = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                AddToCart cart = new AddToCart();
                cart.setUserId(rs.getInt("UserID"));
                cart.setProductId(rs.getInt("ProductID"));
                cart.setQuantity(rs.getInt("Quantity"));
                cart.setUnitPrice(rs.getDouble("UnitPrice"));
                cart.setTotal(rs.getDouble("Total"));
                return cart;
            }
            return null;
        }
    }

    @Override
    public List<AddToCart> getAll() throws SQLException {
        // Not used as we fetch by UserID
        return null;
    }

    public List<AddToCart> getByUserId(int userId) throws SQLException {
        List<AddToCart> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM AddToCart WHERE UserID = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AddToCart cart = new AddToCart();
                cart.setUserId(rs.getInt("UserID"));
                cart.setProductId(rs.getInt("ProductID"));
                cart.setQuantity(rs.getInt("Quantity"));
                cart.setUnitPrice(rs.getDouble("UnitPrice"));
                cart.setTotal(rs.getDouble("Total"));
                cartItems.add(cart);
            }
            return cartItems;
        }
    }

	@Override
	public List<AddToCart> search(String keyword) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}