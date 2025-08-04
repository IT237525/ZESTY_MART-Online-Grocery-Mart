package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import dao.UserDAO;
import utils.PasswordHasher;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    // Define admin credentials (in real app, store these securely)
    private static final String ADMIN_PHONE = "0771234567";
    private static final String ADMIN_PASSWORD = "admin12"; // In production, use hashed password
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        
        try {
            // Check for admin login first
            if (ADMIN_PHONE.equals(phone) && ADMIN_PASSWORD.equals(password)) {
                HttpSession session = request.getSession();
                User adminUser = new User();
                adminUser.setFirstName("Admin");
                adminUser.setLastName("");
                adminUser.setUserId(0); // Special ID for admin
                session.setAttribute("user", adminUser);
                session.setAttribute("isAdmin", true);
                response.sendRedirect("admin.jsp");
                return;
            }
            
            // Regular user login
            UserDAO userDAO = new UserDAO();
            User user = userDAO.search(phone).stream().findFirst().orElse(null);
            
            if (user != null && PasswordHasher.checkPassword(password, user.getPassword())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("isAdmin", false);
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("loginError", "Invalid phone number or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("loginError", "An error occurred during login");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}