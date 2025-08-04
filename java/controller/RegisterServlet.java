package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import dao.UserDAO;
import utils.PasswordHasher;

import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

@MultipartConfig
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("Register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("fname");
        String lastName = request.getParameter("lname");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        Part filePart = request.getPart("profileImage");
        byte[] profileImage = null;
        String profileImageType = null;
        
        if (filePart != null && filePart.getSize() > 0) {
            profileImage = filePart.getInputStream().readAllBytes();
            profileImageType = filePart.getContentType();
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            forwardWithAttributes(request, response, firstName, lastName, gender, phone, address);
            return;
        }
        
        try {
            UserDAO userDAO = new UserDAO();
            
            // Check if phone number already exists
            if (!userDAO.search(phone).isEmpty()) {
                request.setAttribute("error", "Phone number already registered");
                forwardWithAttributes(request, response, firstName, lastName, gender, phone, address);
                return;
            }
            
            String hashedPassword = PasswordHasher.hashPassword(password);
            User newUser = new User(0, firstName, lastName, gender, phone, address, hashedPassword, profileImage, profileImageType);
            
            if (userDAO.insert(newUser)) {
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                forwardWithAttributes(request, response, firstName, lastName, gender, phone, address);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration");
            forwardWithAttributes(request, response, firstName, lastName, gender, phone, address);
        }
    }
    
    private void forwardWithAttributes(HttpServletRequest request, HttpServletResponse response, 
            String fname, String lname, String gender, String phone, String address) 
            throws ServletException, IOException {
        request.setAttribute("fname", fname);
        request.setAttribute("lname", lname);
        request.setAttribute("gender", gender);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.getRequestDispatcher("Register.jsp").forward(request, response);
    }
}