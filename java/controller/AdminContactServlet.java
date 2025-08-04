package controller;

import dao.ContactDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Contact;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin-contact")
public class AdminContactServlet extends HttpServlet {
    private ContactDAO contactDAO;

    @Override
    public void init() {
        contactDAO = new ContactDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("delete".equals(action)) {
                handleDelete(request, response);
            } else {
                listContacts(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("update".equals(action)) {
                handleUpdate(request, response);
            } else if ("search".equals(action)) {
                handleSearch(request, response);
            } else if ("delete".equals(action)) {  // Add this condition
                handleDelete(request, response);
            } else {
                listContacts(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listContacts(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        List<Contact> contacts = contactDAO.getAll();
        request.setAttribute("contacts", contacts);
        request.getRequestDispatcher("/adminContact.jsp").forward(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Contact> contacts = contactDAO.search(keyword);
        request.setAttribute("contacts", contacts);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("/adminContact.jsp").forward(request, response);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        contactDAO.delete(id);
        response.sendRedirect("admin-contact?success=deleted");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int contactId = Integer.parseInt(request.getParameter("contactId"));
        String reply = request.getParameter("reply");
        contactDAO.updateReply(contactId, reply);
        response.sendRedirect("admin-contact?success=updated");
    }
}