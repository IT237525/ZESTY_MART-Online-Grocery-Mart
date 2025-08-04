package controller;

import dao.DeletedUserDAO;
import dao.UserDAO;
import model.DeletedUser;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/user-management")
public class UserManagementServlet extends HttpServlet {
    private UserDAO userDAO;
    private DeletedUserDAO deletedUserDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        deletedUserDAO = new DeletedUserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userId = request.getParameter("userId");
        List<User> activeUsers = new ArrayList<>();
        List<DeletedUser> deletedUsers = new ArrayList<>();

        try {
            if (userId != null && !userId.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(userId);
                    // Search in active users
                    User user = userDAO.getById(id);
                    if (user != null) {
                        activeUsers.add(user);
                    }
                    // Search in deleted users by UserID
                    List<DeletedUser> allDeletedUsers = deletedUserDAO.getAll();
                    for (DeletedUser deletedUser : allDeletedUsers) {
                        if (deletedUser.getUserId() == id) {
                            deletedUsers.add(deletedUser);
                        }
                    }
                    if (activeUsers.isEmpty() && deletedUsers.isEmpty()) {
                        request.setAttribute("error", "No user found with ID: " + id);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid User ID format");
                }
            } else {
                // Fetch all users
                activeUsers = userDAO.getAll();
                deletedUsers = deletedUserDAO.getAll();
                // Debug: Check if data is retrieved
                if (activeUsers == null || activeUsers.isEmpty()) {
                    request.setAttribute("error", "No active users found in database");
                }
                if (deletedUsers == null || deletedUsers.isEmpty()) {
                    String currentError = (String) request.getAttribute("error");
                    request.setAttribute("error", currentError != null ? 
                        currentError + "; No deleted users found in database" : 
                        "No deleted users found in database");
                }
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            e.printStackTrace(); // Log for debugging
        } catch (Exception e) {
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
            e.printStackTrace(); // Log for debugging
        }

        // Debug: Check if profile images are loaded
        for (User user : activeUsers) {
            if (user.getProfileImage() != null) {
                System.out.println("User ID " + user.getUserId() + " has profile image of length: " + user.getProfileImage().length);
            }
        }
        for (DeletedUser deletedUser : deletedUsers) {
            if (deletedUser.getProfileImage() != null) {
                System.out.println("Deleted User ID " + deletedUser.getDeletedUserId() + " has profile image of length: " + deletedUser.getProfileImage().length);
            }
        }

        // Set attributes for JSP
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("deletedUsers", deletedUsers);
        request.getRequestDispatcher("/adminuser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        StringBuilder jsonResponse = new StringBuilder();

        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                // The trigger handles moving data to DeletedUsers
                boolean success = userDAO.delete(userId);
                if (success) {
                    jsonResponse.append("{\"status\":\"success\",\"message\":\"User deleted successfully\"}");
                } else {
                    jsonResponse.append("{\"status\":\"error\",\"message\":\"Failed to delete user with ID: ").append(userId).append("\"}");
                }
            } else if ("restore".equals(action)) {
                int deletedUserId = Integer.parseInt(request.getParameter("deletedUserId"));
                // The before_deleteduser_delete trigger will handle re-insertion into Users
                boolean success = deletedUserDAO.delete(deletedUserId);
                if (success) {
                    jsonResponse.append("{\"status\":\"success\",\"message\":\"User restored successfully\"}");
                } else {
                    jsonResponse.append("{\"status\":\"error\",\"message\":\"Failed to restore user with DeletedUserID: ").append(deletedUserId).append("\"}");
                }
            } else {
                jsonResponse.append("{\"status\":\"error\",\"message\":\"Invalid action\"}");
            }
        } catch (SQLException e) {
            jsonResponse.append("{\"status\":\"error\",\"message\":\"Database error: ").append(escapeJson(e.getMessage())).append("\"}");
            e.printStackTrace(); // Log for debugging
        } catch (NumberFormatException e) {
            jsonResponse.append("{\"status\":\"error\",\"message\":\"Invalid ID format\"}");
        } catch (Exception e) {
            jsonResponse.append("{\"status\":\"error\",\"message\":\"Unexpected error: ").append(escapeJson(e.getMessage())).append("\"}");
            e.printStackTrace(); // Log for debugging
        }

        out.print(jsonResponse.toString());
        out.flush();
    }

    // Helper method to escape JSON strings
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}