package controller;

import dao.CartDAO;
import dao.OrderDAO;
import model.AddToCart;
import model.Order;
import model.OrderDetail;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private CartDAO cartDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp?returnUrl=" + java.net.URLEncoder.encode("CheckoutServlet", "UTF-8"));
            return;
        }

        try {
            List<AddToCart> cartItems = cartDAO.getByUserId(user.getUserId());
            if (cartItems.isEmpty()) {
                request.setAttribute("error", "Your cart is empty. Add items to proceed to checkout.");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            double grandTotal = 0;
            for (AddToCart item : cartItems) {
                grandTotal += item.getTotal();
            }

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("grandTotal", grandTotal);
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading cart: " + e.getMessage());
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp?returnUrl=" + java.net.URLEncoder.encode("CheckoutServlet", "UTF-8"));
            return;
        }

        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        if (address == null || address.trim().isEmpty() || paymentMethod == null || paymentMethod.trim().isEmpty()) {
            request.setAttribute("error", "Please provide shipping address and payment method.");
            try {
                List<AddToCart> cartItems = cartDAO.getByUserId(user.getUserId());
                request.setAttribute("cartItems", cartItems);
                double grandTotal = 0;
                for (AddToCart item : cartItems) {
                    grandTotal += item.getTotal();
                }
                request.setAttribute("grandTotal", grandTotal);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        try {
            // Get cart items
            List<AddToCart> cartItems = cartDAO.getByUserId(user.getUserId());
            if (cartItems.isEmpty()) {
                request.setAttribute("error", "Your cart is empty. Add items to proceed to checkout.");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // Calculate total
            double grandTotal = 0;
            List<OrderDetail> orderDetails = new ArrayList<>();
            for (AddToCart item : cartItems) {
                grandTotal += item.getTotal();
                OrderDetail detail = new OrderDetail(0, item.getProductId(), item.getQuantity(), item.getUnitPrice(), item.getTotal());
                orderDetails.add(detail);
            }

            // Create order
            Order order = new Order(user.getUserId(), grandTotal, orderDetails);

            // Save order to database
            boolean success = orderDAO.insert(order);
            if (success) {
                // Store order ID in session for confirmation page
                session.setAttribute("orderId", order.getOrderId());
                response.sendRedirect("orderconfirmation.jsp");
            } else {
                request.setAttribute("error", "Failed to place order. Please try again.");
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("grandTotal", grandTotal);
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error placing order: " + e.getMessage());
            try {
                List<AddToCart> cartItems = cartDAO.getByUserId(user.getUserId());
                request.setAttribute("cartItems", cartItems);
                double grandTotal = 0;
                for (AddToCart item : cartItems) {
                    grandTotal += item.getTotal();
                }
                request.setAttribute("grandTotal", grandTotal);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}