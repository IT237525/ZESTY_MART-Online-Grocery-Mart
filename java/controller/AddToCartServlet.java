package controller;

import dao.CartDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AddToCart;
import model.Product;
import model.User;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
        System.out.println("AddToCartServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Integer userId = null;

        if (user != null) {
            userId = user.getUserId();
            System.out.println("Logged in user ID: " + userId);
        } else {
            System.out.println("No user found in session.");
        }

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin != null && isAdmin && userId == null) {
            System.out.println("Admin attempted to add to cart.");
            request.setAttribute("error", "Admins cannot add items to cart.");
            request.getRequestDispatcher("productinfo.jsp").forward(request, response);
            return;
        }

        String productIdStr = request.getParameter("productId");
        if (productIdStr == null) {
            System.out.println("No productId found in request.");
            request.setAttribute("error", "Invalid product ID.");
            request.getRequestDispatcher("productinfo.jsp").forward(request, response);
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        System.out.println("Product ID to add: " + productId);

        if (userId == null) {
            session.setAttribute("pendingCartProductId", productId);
            String returnUrl = "AddToCartServlet?productId=" + productId;
            response.sendRedirect("login.jsp?returnUrl=" + java.net.URLEncoder.encode(returnUrl, "UTF-8"));
            return;
        }

        try {
            Product product = productDAO.getById(productId);
            System.out.println("Fetched product: " + (product != null ? product.getName() + ", Stock: " + product.getStock() : "null"));

            if (product == null || product.getStock() <= 0) {
                System.out.println("Product not available or out of stock.");
                request.setAttribute("error", "Product not available or out of stock.");
                request.getRequestDispatcher("productinfo.jsp").forward(request, response);
                return;
            }

            AddToCart cartItem = cartDAO.getByUserAndProduct(userId, productId);
            System.out.println("Cart item exists already: " + (cartItem != null));

            if (cartItem == null) {
                cartItem = new AddToCart(userId, productId, 1, product.getPrice(), product.getPrice(), product.getName(), product.getImage());
                boolean inserted = cartDAO.insert(cartItem);
                System.out.println("Insert new cart item: " + inserted);
            } else {
                int newQuantity = cartItem.getQuantity() + 1;
                System.out.println("New quantity: " + newQuantity);

                if (newQuantity > product.getStock()) {
                    System.out.println("Requested quantity exceeds available stock.");
                    request.setAttribute("error", "Requested quantity exceeds available stock.");
                    request.getRequestDispatcher("productinfo.jsp").forward(request, response);
                    return;
                }

                cartItem.setQuantity(newQuantity);
                cartItem.setTotal(newQuantity * cartItem.getUnitPrice());
                boolean updated = cartDAO.update(cartItem);
                System.out.println("Update existing cart item: " + updated);
            }

            product.setStock(product.getStock() - 1);
            boolean stockUpdated = productDAO.update(product);
            System.out.println("Updated product stock: " + stockUpdated + ", New stock: " + product.getStock());

            session.removeAttribute("pendingCartProductId");
            response.sendRedirect("CartServlet");
        } catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Database error: " + e.getMessage());
        }
    }
}
