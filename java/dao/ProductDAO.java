package dao;

import model.Product;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO implements BaseDAO<Product> {

    // Optional: Insert product with custom image name
    public boolean insertProduct(Product product, String imageName) {
        String sql = "INSERT INTO Product (Name, CategoryID, UnitPrice, Stock, Description, Image) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setInt(2, product.getCategoryId());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setString(5, product.getDescription());
            ps.setString(6, imageName);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error inserting product: " + e.getMessage());
            return false;
        }
    }

    // Standard insert from BaseDAO
    @Override
    public boolean insert(Product product) throws SQLException {
        return insertProduct(product, product.getImage());
    }

    @Override
    public boolean update(Product product) throws SQLException {
        String sql = "UPDATE Product SET Name=?, CategoryID=?, UnitPrice=?, Stock=?, Description=?, Image=? WHERE ProductID=?";

        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setInt(2, product.getCategoryId());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setString(5, product.getDescription());
            ps.setString(6, product.getImage());
            ps.setInt(7, product.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM Product WHERE ProductID=?";

        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public Product getById(int id) throws SQLException {
        String sql = "SELECT * FROM Product WHERE ProductID=?";

        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractProduct(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving product by ID: " + e.getMessage());
            throw e;
        }

        return null;
    }

    @Override
    public List<Product> getAll() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Product";

        try (Connection con = DatabaseUtil.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                products.add(extractProduct(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving all products: " + e.getMessage());
            throw e;
        }

        return products;
    }

    @Override
    public List<Product> search(String keyword) throws SQLException {
        List<Product> products = new ArrayList<>();
        String searchQuery = "%" + (keyword != null ? keyword : "") + "%";
        String sql = "SELECT * FROM Product WHERE Name LIKE ? OR CAST(CategoryID AS CHAR) LIKE ?";

        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, searchQuery);
            ps.setString(2, searchQuery);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(extractProduct(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error searching products: " + e.getMessage());
            throw e;
        }

        return products;
    }

    // 🔁 Convenience Methods (not part of interface)
    public boolean deleteProduct(int productId) {
        try {
            return delete(productId);
        } catch (SQLException e) {
            System.err.println("Error deleting product in deleteProduct: " + e.getMessage());
            return false;
        }
    }

    public Product getProductById(int productId) {
        try {
            return getById(productId);
        } catch (SQLException e) {
            System.err.println("Error getting product by ID in getProductById: " + e.getMessage());
            return null;
        }
    }

    public List<Product> getAllProducts() {
        try {
            return getAll();
        } catch (SQLException e) {
            System.err.println("Error getting all products in getAllProducts: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public List<Product> searchProducts(String keyword) {
        try {
            return search(keyword);
        } catch (SQLException e) {
            System.err.println("Error searching products in searchProducts: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    // Utility method to map ResultSet to Product object
    private Product extractProduct(ResultSet rs) throws SQLException {
        Product product = new Product(
                rs.getString("Name"),
                rs.getInt("CategoryID"),
                rs.getDouble("UnitPrice"),
                rs.getInt("Stock"),
                rs.getString("Description"),
                rs.getString("Image")
        );
        product.setId(rs.getInt("ProductID"));
        return product;
    }
}
