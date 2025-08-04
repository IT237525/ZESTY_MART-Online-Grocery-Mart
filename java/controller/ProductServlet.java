package controller;

import dao.ProductDAO;
import model.Product;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/ProductServlet")
@MultipartConfig
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();  // ✅ Create DAO instance

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            int id = Integer.parseInt(request.getParameter("productId"));

            if ("delete".equals(action)) {
                boolean deleted = productDAO.deleteProduct(id);  // ✅ Use instance method
                response.sendRedirect("adminproduct.jsp?" + (deleted ? "success=delete" : "error=delete"));

            } else if ("update".equals(action)) {
                String name = request.getParameter("name");
                int category = Integer.parseInt(request.getParameter("category"));
                double price = Double.parseDouble(request.getParameter("price"));
                int stock = Integer.parseInt(request.getParameter("stock"));
                String description = request.getParameter("description");

                // Retrieve existing product to retain the image
                Product existingProduct = productDAO.getProductById(id);
                if (existingProduct == null) {
                    response.sendRedirect("adminproduct.jsp?error=notfound");
                    return;
                }

                // Handle file upload if new image is provided
                String imageFileName = existingProduct.getImage();  // Preserve existing image filename

                // Get the uploaded image file part
                Part imagePart = request.getPart("image"); // This part handles the uploaded image

                if (imagePart != null && imagePart.getSize() > 0) {
                    // Generate a unique name for the image file
                    String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                    String uploadDir = getServletContext().getRealPath("/") + "images";  // Directory for uploaded files
                    File uploadDirFile = new File(uploadDir);

                    if (!uploadDirFile.exists()) uploadDirFile.mkdirs();  // Create directory if it doesn't exist

                    // Create a new file on the server
                    File file = new File(uploadDir, fileName);
                    imagePart.write(file.getAbsolutePath());

                    // Update the image filename to be stored in the database
                    imageFileName = fileName;
                }

                // Create updated product with new or existing image filename
                Product updatedProduct = new Product(name, category, price, stock, description, imageFileName);
                updatedProduct.setId(id);

                boolean updated = productDAO.update(updatedProduct);  // Use DAO instance method
                response.sendRedirect("adminproduct.jsp?" + (updated ? "success=update" : "error=update"));
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("adminproduct.jsp?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminproduct.jsp?error=server");
        }
    }
}
