<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, utils.DatabaseUtil, model.Product, dao.ProductDAO, java.util.List, java.util.ArrayList" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || !Boolean.TRUE.equals(sessionObj.getAttribute("isAdmin"))) {
        response.sendRedirect("index.jsp?error=unauthorized");
        return;
    }

    ProductDAO productDAO = new ProductDAO();
    List<Product> products = new ArrayList<>();
    String keyword = request.getParameter("search");

    if (keyword != null && !keyword.trim().isEmpty()) {
        products = productDAO.searchProducts(keyword);
    } else {
        products = productDAO.getAllProducts();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #FFF;
            --panel-color: #FFF;
            --text-color: #000;
            --black-light-color: #707070;
            --border-color: #e6e5e5;
            --toggle-color: #DDD;
            --title-icon-color: #fff;
            --table-bg: #f8fafc;
            --table-header-bg: #1e3a8a;
            --table-hover-bg: #eff6ff;
            --card-bg: #ffffff;
            --shadow-color: rgba(0,0,0,0.1);
        }

        body.dark {
            --primary-color: #3A3B3C;
            --panel-color: #242526;
            --text-color: #CCC;
            --black-light-color: #CCC;
            --border-color: #4D4C4C;
            --toggle-color: #FFF;
            --title-icon-color: #CCC;
            --table-bg: #1f2937;
            --table-header-bg: #1e40af;
            --table-hover-bg: #374151;
            --card-bg: #1f2937;
            --shadow-color: rgba(0,0,0,0.3);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--primary-color);
            color: var(--text-color);
            transition: all 0.3s ease;
        }

        body.dark {
            background: linear-gradient(135deg, #1f2937 0%, #111827 100%);
        }

        /* Main content alignment */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            transition: margin-left 0.5s ease;
        }

        nav.close ~ .main-content {
            margin-left: 73px;
        }

        @media (max-width: 1000px) {
            .main-content {
                margin-left: 73px;
            }
            nav.close ~ .main-content {
                margin-left: 250px;
            }
        }

        @media (max-width: 400px) {
            .main-content {
                margin-left: 0;
            }
            nav.close ~ .main-content {
                margin-left: 73px;
            }
        }

        /* Popup styles */
        .popup {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 1000;
        }

        .popup-content {
            background: var(--card-bg);
            margin: 5% auto;
            padding: 24px;
            width: 90%;
            max-width: 600px;
            max-height: 85vh;
            overflow-y: auto;
            border-radius: 12px;
            position: relative;
            box-shadow: 0 10px 30px var(--shadow-color);
        }

        .popup-content::-webkit-scrollbar {
            display: none;
        }

        .popup-content {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        .close-btn {
            position: absolute;
            top: 12px;
            right: 12px;
            background: #dc2626;
            color: white;
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: transform 0.2s, background 0.2s;
        }

        .close-btn:hover {
            transform: scale(1.1);
            background: #b91c1c;
        }

        /* Table styles */
        .table-container {
            max-height: 60vh;
            overflow-y: auto;
            border-radius: 8px;
        }

        .table-container::-webkit-scrollbar {
            display: none;
        }

        .table-container {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        .product-table th,
        .product-table td {
            padding: 16px;
            text-align: center;
            word-wrap: break-word;
        }

        .product-table th {
            background: var(--table-header-bg);
            color: white;
            font-weight: 600;
        }

        .product-table tr {
            transition: background 0.2s;
            background: var(--card-bg);
        }

        .product-table tr:hover {
            background: var(--table-hover-bg);
        }

        .product-table tr:nth-child(even) {
            background: var(--table-bg);
        }

        /* Button styles */
        .btn {
            transition: transform 0.2s, background 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        /* Input styles */
        .input-field, select {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 10px;
            width: 100%;
            background: var(--panel-color);
            color: var(--text-color);
            transition: border-color 0.2s;
        }

        .input-field:focus, select:focus {
            border-color: #3b82f6;
            outline: none;
        }

        /* Card styles */
        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 4px 20px var(--shadow-color);
            padding: 24px;
        }

        /* Heading styles */
        h1 {
            font-weight: 700;
            color: var(--table-header-bg);
        }

        body.dark h1 {
            color: #3b82f6;
        }

        label {
            color: var(--black-light-color);
            font-weight: 500;
            display: block;
            margin-bottom: 0.5rem;
        }

        /* Message and Error styles */
        .message, .error {
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .message {
            background: #d4edda;
            color: #155724;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <%@ include file="adminheader.jsp" %>
    <div class="main-content">
        <div class="card">
            <h1 class="text-4xl font-bold mb-8 text-center"><i class="fas fa-box-open mr-3"></i>Product Management</h1>

            <%
                String message = null;
                String messageType = null;
                if (request.getParameter("success") != null) {
                    messageType = "message";
                    switch (request.getParameter("success")) {
                        case "1": message = "Product added successfully!"; break;
                        case "update": message = "Product updated successfully!"; break;
                        case "delete": message = "Product deleted successfully!"; break;
                    }
                } else if (request.getParameter("error") != null) {
                    messageType = "error";
                    switch (request.getParameter("error")) {
                        case "add": message = "Failed to add product."; break;
                        case "update": message = "Failed to update product."; break;
                        case "delete": message = "Failed to delete product."; break;
                        default: message = "An unexpected error occurred."; break;
                    }
                }
                if (message != null) {
            %>
                <div class="<%= messageType %>"><%= message %></div>
            <% } %>

            <!-- Add Product Button and Search Bar -->
            <div class="mb-6 flex justify-between items-center">
                <!-- Updated Add Product Button -->
				<button onclick="openAddProductPopup()" class="bg-blue-600 text-white px-5 py-2.5 rounded-lg btn">
				    <i class="fas fa-plus mr-2"></i>Add Product
				</button>

                <form action="adminproduct.jsp" method="get" class="flex items-center">
                    <input type="text" name="search" placeholder="Search by name or category" class="input-field w-72 mr-2" value="<%= keyword != null ? keyword : "" %>">
                    <button type="submit" class="bg-gray-600 text-white px-5 py-2.5 rounded-lg btn"><i class="fas fa-search"></i></button>
                </form>
            </div>

            <!-- Product Table -->
            <div class="table-container">
                <table class="min-w-full rounded-lg product-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category ID</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Description</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (products != null && !products.isEmpty()) { %>
                            <% for (Product product : products) { %>
                                <tr>
                                    <td><%= product.getId() %></td>
                                    <td><%= product.getName() %></td>
                                    <td><%= product.getCategoryId() %></td>
                                    <td><%= product.getPrice() %></td>
                                    <td><%= product.getStock() %></td>
                                    <td><%= product.getDescription() %></td>
                                    <td>
                                        <button class="bg-yellow-500 text-white px-4 py-2 rounded-lg btn" onclick="openEditModal('<%= product.getId() %>')">
                                            <i class="fas fa-edit mr-2"></i>Edit
                                        </button>
                                    </td>
                                </tr>
                                
                                <!-- Edit Popup -->
                                <div class="popup" id="editPopup-<%= product.getId() %>">
						            <div class="popup-content">
						                <button class="close-btn" onclick="closeEditModal('<%= product.getId() %>')"><i class="fas fa-times"></i></button>

						                <h2 class="text-2xl font-bold mb-6"><i class="fas fa-edit mr-2"></i>Edit Product</h2>
						                <form id="editForm" action="ProductServlet" method="post" enctype="multipart/form-data">
						                   
						                    <input type="hidden" name="productId" value="<%= product.getId() %>">
						                    <div class="mb-5">
						                        <label class="block mb-2">Name</label>
						                        <input type="text" name="name" class="input-field" value="<%= product.getName() %>">
						                    </div>
						                    <div class="mb-5">
						                        <label class="block mb-2">Category ID</label>
						                        <input type="text" name="category" class="input-field" value="<%= product.getCategoryId() %>"readonly>
						                    </div>
						                    <div class="mb-5">
						                        <label class="block mb-2">Price</label>
						                        <input type="number" step="0.01" name="price" class="input-field" value="<%= product.getPrice() %>">
						                    </div>
						                    <div class="mb-5">
						                        <label class="block mb-2">Stock</label>
						                        <input type="number" name="stock" class="input-field" value="<%= product.getStock() %>">
						                    </div>
						                    <div class="mb-5">
						                        <label class="block mb-2">Description</label>
						                        <input type="text" name="description" class="input-field" value="<%= product.getDescription() %>">
						                    </div>
						                    <div class="mb-5">
						                        <label class="block mb-2">Image</label>
						                        <input type="file" name="image" id="editImage" class="input-field" accept="image/*">
						                    </div>
						                    <div class="flex justify-between">
						                         <button type="submit" name="action" value="delete" onclick="return confirm('Are you sure you want to delete this product?')" class="bg-red-600 text-white px-4 py-2 rounded-lg btn">
												    <i class="fas fa-trash mr-2"></i>Delete
												</button>

						                        <button type="submit" name="action" value="update" class="bg-green-600 text-white px-4 py-2 rounded-lg btn">
						                        	<i class="fas fa-save mr-2"></i>Update
						                        </button>
						                    </div>                    
						                </form>                
						            </div>
						        </div>
						        
						    </div>
                            <% } %>
                        <% } else { %>
                            <tr><td colspan="7" class="text-center">No products found.</td></tr>
                        <% } %>   
   
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Add Product Popup -->
		<div class="popup" id="addProductPopup">
		    <div class="popup-content">
		         <button class="close-btn" onclick="closeAddProductPopup()"><i class="fas fa-times"></i></button>
        		   	<%@ include file="addproducts.jsp" %>
		    </div>
		</div>
        

   
    

    <script>
		    
	    function openEditModal(id) {
	        document.getElementById('editPopup-' + id).style.display = 'flex';
	    }
	
	    function closeEditModal(id) {
	        document.getElementById('editPopup-' + id).style.display = 'none';
	    }
	
	    // Close modal if clicked outside
	    window.onclick = function(event) {
	        const modals = document.querySelectorAll(".popup");
	        modals.forEach(function(modal) {
	            if (event.target === modal) {
	                modal.style.display = "none";
	            }
	        });
	    };   
        
        function openAddProductPopup() {
            document.getElementById('addProductPopup').style.display = 'block';
        }

        function closeAddProductPopup() {
            document.getElementById('addProductPopup').style.display = 'none';
        }


        // Ensure dark mode is applied on page load
        if (localStorage.getItem("darkMode") === "enabled") {
            document.body.classList.add("dark");
        }
    </script>
</body>
</html>