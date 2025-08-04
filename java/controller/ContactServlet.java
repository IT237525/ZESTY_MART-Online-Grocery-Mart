package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import dao.ContactDAO;
import model.Contact;
import model.User;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("viewMessages".equals(action)) {
                viewUserMessages(request, response);
            } else {
                showContactForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing your request: " + e.getMessage());
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("submit".equals(action)) {
                submitContactForm(request, response);
            } else {
                showContactForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error submitting your message: " + e.getMessage());
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        }
    }
    
    private void showContactForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("user") != null) {
            try {
                User user = (User) session.getAttribute("user");
                ContactDAO contactDAO = new ContactDAO();
                List<Contact> userContacts = contactDAO.getByUserId(user.getUserId());
                
                if (userContacts != null && !userContacts.isEmpty()) {
                    request.setAttribute("userContacts", userContacts);
                }
            } catch (SQLException e) {
                // Just log the error, don't stop the page from loading
                e.printStackTrace();
            }
        }
        
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
    
    private void submitContactForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        // Get form parameters
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String userIdStr = request.getParameter("userId");
        
        Integer userId = null;
        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try {
                userId = Integer.parseInt(userIdStr);
            } catch (NumberFormatException e) {
                userId = null; // In case of invalid userId format
            }
        }
        
        // Create new Contact object
        Contact contact = new Contact();
        contact.setUserID(userId);
        contact.setName(name);
        contact.setPhone(phone);
        contact.setSubject(subject);
        contact.setMessage(message);
        contact.setReply(""); // Empty reply initially
        contact.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        
        // Save to database
        ContactDAO contactDAO = new ContactDAO();
        boolean success = contactDAO.insert(contact);
        
        if (success) {
            // For demo purposes, add an automatic reply
            // In a real application, an admin would respond later
            String autoReply = "Thank you for contacting us! We have received your message and will respond shortly. If you need immediate assistance, please call our customer service at +123-456-7890.";
            contactDAO.updateReply(contact.getContactID(), autoReply);
            
            // Get the updated contact with reply
            contact = contactDAO.getById(contact.getContactID());
            
            // Set success message and submitted contact
            request.setAttribute("successMessage", "Your message has been sent successfully!");
            request.setAttribute("submittedContact", contact);
            
            // If user is logged in, get all their contacts
            if (userId != null) {
                List<Contact> userContacts = contactDAO.getByUserId(userId);
                request.setAttribute("userContacts", userContacts);
            }
        } else {
            request.setAttribute("errorMessage", "Failed to send your message. Please try again later.");
        }
        
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
    
    private void viewUserMessages(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            
            ContactDAO contactDAO = new ContactDAO();
            List<Contact> userContacts = contactDAO.getByUserId(user.getUserId());
            
            request.setAttribute("userContacts", userContacts);
        } else {
            // If not logged in, redirect to login page
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
}