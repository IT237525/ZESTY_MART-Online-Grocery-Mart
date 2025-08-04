package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Product;

@WebServlet("/AddProductServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class AddProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryStr = request.getParameter("category");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String description = request.getParameter("description");

        if (categoryStr == null || name == null || priceStr == null ||
            stockStr == null || description == null ||
            categoryStr.isEmpty() || name.isEmpty() || priceStr.isEmpty() ||
            stockStr.isEmpty() || description.isEmpty()) {

            response.sendRedirect("addproducts.jsp?error=3");
            return;
        }

        try {
            int category = Integer.parseInt(categoryStr);
            double price = Double.parseDouble(priceStr);
            int stock = Integer.parseInt(stockStr);

            Part imagePart = request.getPart("image");
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

            // Ensure the images directory exists
            String uploadPath = getServletContext().getRealPath("/") + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();  // Create the directory if it doesn't exist
            }
            
           
            // Save the uploaded image
            imagePart.write(uploadPath + File.separator + fileName);

            // Insert product into the database
            Product product = new Product(name, category, price, stock, description, fileName);
            ProductDAO productDAO = new ProductDAO();

            if (productDAO.insertProduct(product, fileName)) {
                response.sendRedirect("adminproduct.jsp?success=1");
            } else {
                response.sendRedirect("addproducts.jsp?error=1");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("addproducts.jsp?error=4");
        }
    }
}
