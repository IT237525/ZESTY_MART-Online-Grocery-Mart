package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import dao.UserDAO;
import utils.PasswordHasher;

import java.io.IOException;
import java.sql.SQLException;

@MultipartConfig
@WebServlet(name = "ProfileServlet", value = {"/profile", "/update-profile", "/profile-image"})
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/profile-image".equals(path)) {
            handleProfileImage(request, response);
        } else {
            response.sendRedirect("profile.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/update-profile".equals(path)) {
            updateProfile(request, response);
        } else {
            response.sendRedirect("profile.jsp");
        }
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("basic-info".equals(action)) {
                updateBasicInfo(request, response, currentUser);
            } else if ("credentials".equals(action)) {
                updatePassword(request, response, currentUser);
            } else if ("profile-picture".equals(action)) {
                updateProfilePicture(request, response, currentUser);
            } else if ("change-phone".equals(action)) {
                updatePhone(request, response, currentUser);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred while updating your profile");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
    
    private void updateBasicInfo(HttpServletRequest request, HttpServletResponse response, 
            User currentUser) throws ServletException, IOException, SQLException {
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        
        // Create a new User object with updated information
        User updatedUser = new User(
            currentUser.getUserId(),
            firstName,
            lastName,
            gender,
            currentUser.getPhone(), // Keep original phone
            address,
            currentUser.getPassword(),
            currentUser.getProfileImage(),
            currentUser.getProfileImageType()
        );
        
        if (userDAO.update(updatedUser)) {
            request.setAttribute("success", "Profile updated successfully");
            request.getSession().setAttribute("user", updatedUser);
        } else {
            request.setAttribute("error", "Failed to update profile");
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    private void updatePassword(HttpServletRequest request, HttpServletResponse response, 
            User currentUser) throws ServletException, IOException, SQLException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!PasswordHasher.checkPassword(currentPassword, currentUser.getPassword())) {
            request.setAttribute("error", "Current password is incorrect");
        } else if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match");
        } else {
            User updatedUser = new User(
                currentUser.getUserId(),
                currentUser.getFirstName(),
                currentUser.getLastName(),
                currentUser.getGender(),
                currentUser.getPhone(),
                currentUser.getAddress(),
                PasswordHasher.hashPassword(newPassword),
                currentUser.getProfileImage(),
                currentUser.getProfileImageType()
            );
            
            if (userDAO.update(updatedUser)) {
                request.setAttribute("success", "Password updated successfully");
                request.getSession().setAttribute("user", updatedUser);
            } else {
                request.setAttribute("error", "Failed to update password");
            }
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    private void updateProfilePicture(HttpServletRequest request, HttpServletResponse response, 
            User currentUser) throws ServletException, IOException, SQLException {
        Part filePart = request.getPart("profileImage");
        byte[] profileImage = currentUser.getProfileImage();
        String profileImageType = currentUser.getProfileImageType();
        
        if (filePart != null && filePart.getSize() > 0) {
            profileImage = filePart.getInputStream().readAllBytes();
            profileImageType = filePart.getContentType();
        } else {
            request.setAttribute("error", "No image file selected");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        User updatedUser = new User(
            currentUser.getUserId(),
            currentUser.getFirstName(),
            currentUser.getLastName(),
            currentUser.getGender(),
            currentUser.getPhone(),
            currentUser.getAddress(),
            currentUser.getPassword(),
            profileImage,
            profileImageType
        );
        
        if (userDAO.update(updatedUser)) {
            request.setAttribute("success", "Profile picture updated successfully");
            request.getSession().setAttribute("user", updatedUser);
        } else {
            request.setAttribute("error", "Failed to update profile picture");
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    private void updatePhone(HttpServletRequest request, HttpServletResponse response, 
            User currentUser) throws ServletException, IOException, SQLException {
        String currentPassword = request.getParameter("currentPassword");
        String newPhone = request.getParameter("newPhone");
        
        if (!PasswordHasher.checkPassword(currentPassword, currentUser.getPassword())) {
            request.setAttribute("error", "Current password is incorrect");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        // Check if new phone number already exists
        if (!userDAO.search(newPhone).isEmpty()) {
            request.setAttribute("error", "This phone number is already registered");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        User updatedUser = new User(
            currentUser.getUserId(),
            currentUser.getFirstName(),
            currentUser.getLastName(),
            currentUser.getGender(),
            newPhone,
            currentUser.getAddress(),
            currentUser.getPassword(),
            currentUser.getProfileImage(),
            currentUser.getProfileImageType()
        );
        
        if (userDAO.update(updatedUser)) {
            request.setAttribute("success", "Phone number updated successfully");
            request.getSession().setAttribute("user", updatedUser);
        } else {
            request.setAttribute("error", "Failed to update phone number");
        }
        
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    private void handleProfileImage(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String type = request.getParameter("type");
        
        try {
            User user = userDAO.getById(Integer.parseInt(id));
            
            if (user != null && user.getProfileImage() != null) {
                response.setContentType(user.getProfileImageType());
                response.getOutputStream().write(user.getProfileImage());
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException | SQLException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user ID");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}