package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Category;
import dao.CategoryDAO;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/CategoryServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB limit
public class CategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession(false) == null ||
            request.getSession().getAttribute("isAdmin") == null ||
            !Boolean.TRUE.equals(request.getSession().getAttribute("isAdmin"))) {
            response.sendRedirect("index.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("Action received: " + action);

        try {
            switch (action) {
                case "add":
                    addCategory(request, response);
                    break;
                case "edit":
                    editCategory(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    response.sendRedirect("admincategory.jsp?message=Error: Invalid action");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admincategory.jsp?message=Error: " + e.getMessage());
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String description = request.getParameter("description");
        Part filePart = request.getPart("image");
        String imageUrl = null;

        System.out.println("Add category: description=" + description + ", filePart=" + (filePart != null ? filePart.getSubmittedFileName() : "null"));

        if (description != null && !description.trim().isEmpty()) {
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                if (!fileName.matches(".*\\.(jpg|jpeg|png|gif)$")) {
                    response.sendRedirect("admincategory.jsp?message=Error: Invalid image format");
                    return;
                }
                String uploadPath = getServletContext().getRealPath("") + File.separator + "Uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    if (!uploadDir.mkdirs()) {
                        response.sendRedirect("admincategory.jsp?message=Error: Failed to create upload directory");
                        return;
                    }
                }
                if (!uploadDir.canWrite()) {
                    response.sendRedirect("admincategory.jsp?message=Error: Upload directory is not writable");
                    return;
                }
                String filePath = uploadPath + File.separator + fileName;
                try {
                    filePart.write(filePath);
                    imageUrl = "Uploads/" + fileName;
                } catch (IOException e) {
                    e.printStackTrace();
                    response.sendRedirect("admincategory.jsp?message=Error: Failed to save image - " + e.getMessage());
                    return;
                }
            }

            Category category = new Category();
            category.setDescription(description);
            category.setImage(imageUrl);

            try {
                if (categoryDAO.insert(category)) {
                    getServletContext().removeAttribute("categories");
                    response.sendRedirect("admincategory.jsp?message=Category added successfully");
                } else {
                    response.sendRedirect("admincategory.jsp?message=Error: Failed to add category");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("admincategory.jsp?message=Error: Database error - " + e.getMessage());
            }
        } else {
            response.sendRedirect("admincategory.jsp?message=Error: Description is required");
        }
    }

    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String description = request.getParameter("description");
            Part filePart = request.getPart("image");
            String imageUrl = request.getParameter("existingImage");

            System.out.println("Edit category: id=" + categoryId + ", description=" + description + ", filePart=" + (filePart != null ? filePart.getSubmittedFileName() : "null") + ", existingImage=" + imageUrl);

            if (description != null && !description.trim().isEmpty()) {
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = filePart.getSubmittedFileName();
                    if (!fileName.matches(".*\\.(jpg|jpeg|png|gif)$")) {
                        response.sendRedirect("admincategory.jsp?message=Error: Invalid image format");
                        return;
                    }
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "Uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        if (!uploadDir.mkdirs()) {
                            response.sendRedirect("admincategory.jsp?message=Error: Failed to create upload directory");
                            return;
                        }
                    }
                    if (!uploadDir.canWrite()) {
                        response.sendRedirect("admincategory.jsp?message=Error: Upload directory is not writable");
                        return;
                    }
                    String filePath = uploadPath + File.separator + fileName;
                    try {
                        filePart.write(filePath);
                        imageUrl = "Uploads/" + fileName;
                    } catch (IOException e) {
                        e.printStackTrace();
                        response.sendRedirect("admincategory.jsp?message=Error: Failed to save image - " + e.getMessage());
                        return;
                    }
                }

                Category category = new Category();
                category.setCategoryId(categoryId);
                category.setDescription(description);
                category.setImage(imageUrl);

                try {
                    if (categoryDAO.update(category)) {
                        getServletContext().removeAttribute("categories");
                        response.sendRedirect("admincategory.jsp?message=Category updated successfully");
                    } else {
                        response.sendRedirect("admincategory.jsp?message=Error: Failed to update category");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.sendRedirect("admincategory.jsp?message=Error: Database error - " + e.getMessage());
                }
            } else {
                response.sendRedirect("admincategory.jsp?message=Error: Description is required");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("admincategory.jsp?message=Error: Invalid category ID");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            System.out.println("Delete category: id=" + categoryId);

            try {
                if (categoryDAO.delete(categoryId)) {
                    getServletContext().removeAttribute("categories");
                    response.sendRedirect("admincategory.jsp?message=Category deleted successfully");
                } else {
                    response.sendRedirect("admincategory.jsp?message=Error: Failed to delete category");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("admincategory.jsp?message=Error: Database error - " + e.getMessage());
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("admincategory.jsp?message=Error: Invalid category ID");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admincategory.jsp");
    }
}