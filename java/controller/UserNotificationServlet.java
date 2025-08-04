package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.NotificationDAO;
import model.Notification;
import model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/user/notifications")
public class UserNotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NotificationDAO notificationDAO;
    private static final Logger logger = Logger.getLogger(UserNotificationServlet.class.getName());

    @Override
    public void init() throws ServletException {
        super.init();
        notificationDAO = new NotificationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // false means don't create new session
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        try {
            List<Notification> notifications = notificationDAO.getActiveNotificationsByUser(user.getUserId());
            request.setAttribute("notifications", notifications);
            
            // Handle expand parameter safely
            String expandId = request.getParameter("expand");
            if (expandId != null && !expandId.trim().isEmpty()) {
                try {
                    int notificationId = Integer.parseInt(expandId);
                    Notification expandedNotification = notificationDAO.getById(notificationId);
                    
                    // Verify the notification belongs to this user
                    if (expandedNotification != null && expandedNotification.getUserId() == user.getUserId()) {
                        // Mark as read if not already read
                        if (!expandedNotification.isRead()) {
                            notificationDAO.markAsRead(notificationId);
                            expandedNotification.setRead(true);
                        }
                        request.setAttribute("expandedNotification", expandedNotification);
                    }
                } catch (NumberFormatException e) {
                    logger.log(Level.WARNING, "Invalid notification ID format: " + expandId, e);
                }
            }
            
            request.getRequestDispatcher("/notification.jsp").forward(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in NotificationServlet", e);
            request.setAttribute("errorMessage", "A database error occurred. Please try again later.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Unexpected error in NotificationServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        String notificationIdStr = request.getParameter("notificationId");
        
        if (action == null || notificationIdStr == null || notificationIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/notifications");
            return;
        }

        try {
            int notificationId = Integer.parseInt(notificationIdStr);
            
            // Verify the notification belongs to this user before any action
            Notification notification = notificationDAO.getById(notificationId);
            if (notification == null || notification.getUserId() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/user/notifications");
                return;
            }
            
            if ("delete".equals(action)) {
                notificationDAO.markAsDeletedByUser(notificationId);
            }
            
            response.sendRedirect(request.getContextPath() + "/user/notifications");
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid notification ID format: " + notificationIdStr, e);
            response.sendRedirect(request.getContextPath() + "/user/notifications");
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in NotificationServlet POST", e);
            request.setAttribute("errorMessage", "A database error occurred. Please try again later.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}