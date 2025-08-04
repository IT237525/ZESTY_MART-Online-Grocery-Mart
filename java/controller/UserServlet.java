package controller;

import dao.NotificationDAO;
import model.Notification;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String action = request.getParameter("action");
            
            if ("dropdown".equals(action)) {
                List<Notification> notifications = notificationDAO.getActiveNotificationsByUser(user.getUserId());
                request.setAttribute("notifications", notifications);
                request.getRequestDispatcher("/notificationDropdown.jsp").include(request, response);
                return;
            }
            
            if ("count".equals(action)) {
                int unreadCount = notificationDAO.getUnreadNotificationCount(user.getUserId());
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(unreadCount));
                return;
            }

            if ("markAsRead".equals(action)) {
                int notificationId = Integer.parseInt(request.getParameter("notificationId"));
                System.out.println("Processing markAsRead for NotificationID: " + notificationId);
                boolean success = notificationDAO.markAsRead(notificationId);
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(success));
                return;
            }

            List<Notification> notifications = notificationDAO.getActiveNotificationsByUser(user.getUserId());
            request.setAttribute("notifications", notifications);
            request.setAttribute("unreadCount", notificationDAO.getUnreadNotificationCount(user.getUserId()));
            request.getRequestDispatcher("notification.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("Database error in UserServlet: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Database error occurred");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String action = request.getParameter("action");
            
            if ("delete".equals(action)) {
                String id = request.getParameter("id");
                if (id != null) {
                    boolean success = notificationDAO.markAsDeletedByUser(Integer.parseInt(id));
                    response.setContentType("text/plain");
                    response.getWriter().write(String.valueOf(success));
                    return;
                }
            }
            
            if ("markAllAsRead".equals(action)) {
                boolean success = notificationDAO.markAsRead(user.getUserId());
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(success));
                return;
            }

            response.sendRedirect(request.getContextPath() + "/UserServlet");
            
        } catch (SQLException e) {
            System.err.println("Database error in UserServlet: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Failed to process request");
        }
    }
}