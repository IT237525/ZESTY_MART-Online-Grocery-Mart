package dao;

import model.Order;
import model.OrderDetail;
import utils.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO implements BaseDAO<Order> {

    @Override
    public boolean insert(Order order) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmtOrder = null;
        PreparedStatement pstmtDetails = null;
        ResultSet rs = null;

        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Insert into Orders table
            String orderSql = "INSERT INTO Orders (UserID, Total, OrderDateTime, IsDirectOrder) VALUES (?, ?, ?, ?)";
            pstmtOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            pstmtOrder.setInt(1, order.getUserId());
            pstmtOrder.setDouble(2, order.getTotal());
            pstmtOrder.setTimestamp(3, Timestamp.valueOf(order.getOrderDateTime()));
            pstmtOrder.setBoolean(4, order.isDirectOrder());
            int rowsAffected = pstmtOrder.executeUpdate();

            if (rowsAffected == 0) {
                throw new SQLException("Failed to insert order into Orders table");
            }

            // Get the generated OrderID
            rs = pstmtOrder.getGeneratedKeys();
            if (!rs.next()) {
                throw new SQLException("Failed to retrieve OrderID");
            }
            int orderId = rs.getInt(1);
            order.setOrderId(orderId);

            // Insert into OrderDetails table
            String detailsSql = "INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Total) VALUES (?, ?, ?, ?, ?)";
            pstmtDetails = conn.prepareStatement(detailsSql);
            for (OrderDetail detail : order.getOrderDetails()) {
                pstmtDetails.setInt(1, orderId);
                pstmtDetails.setInt(2, detail.getProductId());
                pstmtDetails.setInt(3, detail.getQuantity());
                pstmtDetails.setDouble(4, detail.getUnitPrice());
                pstmtDetails.setDouble(5, detail.getTotal());
                pstmtDetails.addBatch();
            }
            pstmtDetails.executeBatch();

            // Clear the user's cart
            String clearCartSql = "DELETE FROM AddToCart WHERE UserID = ?";
            try (PreparedStatement pstmtClear = conn.prepareStatement(clearCartSql)) {
                pstmtClear.setInt(1, order.getUserId());
                pstmtClear.executeUpdate();
            }

            conn.commit(); // Commit transaction
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pstmtOrder != null) pstmtOrder.close();
            if (pstmtDetails != null) pstmtDetails.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    @Override
    public boolean update(Order order) throws SQLException {
        // Not implemented for this use case
        return false;
    }

    @Override
    public boolean delete(int id) throws SQLException {
        // Not implemented for this use case
        return false;
    }

    @Override
    public Order getById(int id) throws SQLException {
        String sql = "SELECT * FROM Orders WHERE OrderID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Order order = new Order(
                    rs.getInt("UserID"),
                    rs.getDouble("Total"),
                    null
                );
                order.setOrderId(rs.getInt("OrderID"));
                order.setOrderDateTime(rs.getTimestamp("OrderDateTime").toLocalDateTime());
                order.setDirectOrder(rs.getBoolean("IsDirectOrder"));
                order.setOrderDetails(getOrderDetails(id));
                return order;
            }
        }
        return null;
    }

    private List<OrderDetail> getOrderDetails(int orderId) throws SQLException {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetails WHERE OrderID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                OrderDetail detail = new OrderDetail(
                    rs.getInt("OrderID"),
                    rs.getInt("ProductID"),
                    rs.getInt("Quantity"),
                    rs.getDouble("UnitPrice"),
                    rs.getDouble("Total")
                );
                details.add(detail);
            }
        }
        return details;
    }

    @Override
    public List<Order> getAll() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("UserID"),
                    rs.getDouble("Total"),
                    null
                );
                order.setOrderId(rs.getInt("OrderID"));
                order.setOrderDateTime(rs.getTimestamp("OrderDateTime").toLocalDateTime());
                order.setDirectOrder(rs.getBoolean("IsDirectOrder"));
                order.setOrderDetails(getOrderDetails(order.getOrderId()));
                orders.add(order);
            }
        }
        return orders;
    }

    public List<Order> getByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE UserID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("UserID"),
                    rs.getDouble("Total"),
                    null
                );
                order.setOrderId(rs.getInt("OrderID"));
                order.setOrderDateTime(rs.getTimestamp("OrderDateTime").toLocalDateTime());
                order.setDirectOrder(rs.getBoolean("IsDirectOrder"));
                order.setOrderDetails(getOrderDetails(order.getOrderId()));
                orders.add(order);
            }
        }
        return orders;
    }

	@Override
	public List<Order> search(String keyword) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
}