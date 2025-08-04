package controller;

import dao.CartDAO;
import dao.ProductDAO;
import model.AddToCart;
import model.Product;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp?returnUrl=" + java.net.URLEncoder.encode("CartServlet", "UTF-8"));
            return;
        }

        int userId = user.getUserId();

        try {
            // Fetch the updated cart items and pass them to cart.jsp
            List<AddToCart> cartItems = cartDAO.getByUserId(userId);
            request.setAttribute("cartItems", cartItems);
            
            // Forward the request to cart.jsp to display the updated cart
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp?returnUrl=" + java.net.URLEncoder.encode("CartServlet", "UTF-8"));
            return;
        }

        int userId = user.getUserId();
        String action = request.getParameter("action");

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            Product product = productDAO.getById(productId);

            if (product == null) {
                response.sendRedirect("cart.jsp");
                return;
            }

            switch (action) {
                case "increase": {
                    AddToCart existingItem = cartDAO.getByUserAndProduct(userId, productId);
                    if (existingItem == null) {
                        // Insert new item to cart
                        AddToCart newItem = new AddToCart();
                        newItem.setUserId(userId);
                        newItem.setProductId(productId);
                        newItem.setQuantity(1);
                        newItem.setUnitPrice(product.getPrice());
                        newItem.setTotal(product.getPrice());
                        cartDAO.insert(newItem);
                    } else {
                        // Update quantity
                        cartDAO.increaseQuantity(userId, productId, 1);
                    }
                    // Update product stock
                    product.setStock(product.getStock() - 1);
                    productDAO.update(product);
                    break;
                }

                case "decrease": {
                    AddToCart item = cartDAO.getByUserAndProduct(userId, productId);
                    if (item != null && item.getQuantity() > 0) {
                        cartDAO.decreaseQuantity(userId, productId, 1);
                        product.setStock(product.getStock() + 1);
                        productDAO.update(product);
                    }
                    break;
                }

                case "remove": {
                    AddToCart item = cartDAO.getByUserAndProduct(userId, productId);
                    if (item != null) {
                        product.setStock(product.getStock() + item.getQuantity());
                        productDAO.update(product);
                        cartDAO.delete(userId, productId);
                    }
                    break;
                }

                default:
                    // Invalid action
                    break;
            }

            // Refresh and display updated cart
            List<AddToCart> cartItems = cartDAO.getByUserId(userId);
            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("cart.jsp").forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp");
        }
    }

}
