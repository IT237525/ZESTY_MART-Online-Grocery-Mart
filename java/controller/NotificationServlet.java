package controller;

import dao.NotificationDAO;
import dao.UserDAO;
import model.Notification;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchUserId = request.getParameter("searchUserId");
        List<User> users;
        try {
            if (searchUserId != null && !searchUserId.isEmpty()) {
                // Search users by ID
                users = new ArrayList<>();
                User user = userDAO.getById(Integer.parseInt(searchUserId));
                if (user != null) {
                    users.add(user);
                }
            } else {
                // Get all users
                users = userDAO.getAll();
            }
            request.setAttribute("users", users);
            request.getRequestDispatcher("/adminnotification.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error while retrieving users", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action == null ? "" : action) {
                case "add":
                    handleAddNotification(request, response);
                    break;
                case "update":
                    handleUpdateNotification(request, response);
                    break;
                case "delete":
                    handleDeleteNotification(request, response);
                    break;
                case "show":
                    handleShowNotifications(request, response);
                    break;
                case "edit":
                    handleEditNotification(request, response);
                    break;
                default:
                    response.sendRedirect("NotificationServlet");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Database error while processing request", e);
        }
    }

    private void handleAddNotification(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String[] userIds = request.getParameterValues("userIds");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (userIds != null && subject != null && message != null) {
            if (userIds.length == 1 && "all".equals(userIds[0])) {
                // Send to all users
                List<User> users = userDAO.getAll();
                for (User user : users) {
                    Notification notification = new Notification(user.getUserId(), subject, message);
                    notificationDAO.insert(notification);
                }
            } else {
                // Send to selected users
                for (String userId : userIds) {
                    Notification notification = new Notification(Integer.parseInt(userId), subject, message);
                    notificationDAO.insert(notification);
                }
            }
        }
        response.sendRedirect("NotificationServlet");
    }

    private void handleUpdateNotification(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int notificationId = Integer.parseInt(request.getParameter("notificationId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        Notification notification = notificationDAO.getById(notificationId);
        if (notification != null) {
            notification.setSubject(subject);
            notification.setMessage(message);
            notificationDAO.update(notification);
        }
        response.sendRedirect("NotificationServlet?action=show&userId=" + userId);
    }

    private void handleDeleteNotification(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int notificationId = Integer.parseInt(request.getParameter("notificationId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        notificationDAO.delete(notificationId);
        response.sendRedirect("NotificationServlet?action=show&userId=" + userId);
    }

    private void handleShowNotifications(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        List<Notification> notifications = notificationDAO.getByUserId(userId);
        request.setAttribute("notifications", notifications);
        request.setAttribute("userId", userId);
        request.getRequestDispatcher("/adminnotification.jsp").forward(request, response);
    }

    private void handleEditNotification(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int notificationId = Integer.parseInt(request.getParameter("notificationId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        Notification notification = notificationDAO.getById(notificationId);
        request.setAttribute("editNotification", notification);
        request.setAttribute("userId", userId);
        request.getRequestDispatcher("/adminnotification.jsp").forward(request, response);
    }
}