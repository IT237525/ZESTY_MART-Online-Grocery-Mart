package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private int orderId;
    private int userId;
    private double total;
    private LocalDateTime orderDateTime;
    private boolean isDirectOrder;
    private List<OrderDetail> orderDetails;

    // Constructor for direct order (not used here, but included for completeness)
    public Order(int userId, int productId, int quantity, double unitPrice, double total, boolean isDirectOrder) {
        this.userId = userId;
        this.total = total;
        this.orderDateTime = LocalDateTime.now();
        this.isDirectOrder = isDirectOrder;
        this.orderDetails = new ArrayList<>();
        if (isDirectOrder) {
            OrderDetail detail = new OrderDetail(0, productId, quantity, unitPrice, quantity * unitPrice);
            this.orderDetails.add(detail);
        }
    }

    // Constructor for cart-based order
    public Order(int userId, double total, List<OrderDetail> orderDetails) {
        this.userId = userId;
        this.total = total;
        this.orderDateTime = LocalDateTime.now();
        this.isDirectOrder = false;
        this.orderDetails = orderDetails != null ? orderDetails : new ArrayList<>();
    }

    // Getters and setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public LocalDateTime getOrderDateTime() {
        return orderDateTime;
    }

    public void setOrderDateTime(LocalDateTime orderDateTime) {
        this.orderDateTime = orderDateTime;
    }

    public boolean isDirectOrder() {
        return isDirectOrder;
    }

    public void setDirectOrder(boolean directOrder) {
        isDirectOrder = directOrder;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }
}