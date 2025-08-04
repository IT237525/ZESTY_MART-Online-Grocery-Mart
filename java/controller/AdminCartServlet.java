package controller;

import dao.CartDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/cart-management")
public class AdminCartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        boolean isAdmin = (session != null) && Boolean.TRUE.equals(session.getAttribute("isAdmin"));

        if (!isAdmin) {
            out.print("{\"status\":\"unauthorized\"}");
            return;
        }

        String action = request.getParameter("action");

        if ("deleteCartItem".equalsIgnoreCase(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int productId = Integer.parseInt(request.getParameter("productId"));
                boolean deleted = cartDAO.delete(userId, productId);

                if (deleted) {
                    out.print("{\"status\":\"success\"}");
                } else {
                    out.print("{\"status\":\"fail\"}");
                }
            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
                out.print("{\"status\":\"error\"}");
            }
        } else {
            out.print("{\"status\":\"invalid_action\"}");
        }
    }
}