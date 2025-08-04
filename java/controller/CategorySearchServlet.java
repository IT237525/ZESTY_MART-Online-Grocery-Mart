package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.CategoryDAO;
import model.Category;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/CategorySearchServlet")
public class CategorySearchServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession();
        String keyword = request.getParameter("keyword");
        String action = request.getParameter("action");
        List<Category> categories = null;

        try {
            // Handle back action
            if ("back".equals(action)) {
                @SuppressWarnings("unchecked")
                List<String> searchHistory = (List<String>) session.getAttribute("searchHistory");
                if (searchHistory != null && !searchHistory.isEmpty()) {
                    if (searchHistory.size() > 1) {
                        searchHistory.remove(searchHistory.size() - 1); // Remove current keyword
                        keyword = searchHistory.get(searchHistory.size() - 1);
                    } else {
                        keyword = null; // Go back to all categories
                        searchHistory.clear();
                    }
                    session.setAttribute("searchHistory", searchHistory);
                }
            }

            // Perform search or get all categories
            if (keyword != null && !keyword.trim().isEmpty()) {
                categories = categoryDAO.search(keyword);
            } else {
                categories = categoryDAO.getAll();
            }

            request.setAttribute("categories", categories);
            request.getRequestDispatcher("shop.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load categories: " + e.getMessage());
            request.getRequestDispatcher("shop.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed (e.g., closing DAO resources)
        categoryDAO = null;
        super.destroy();
    }
}