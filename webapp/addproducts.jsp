<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, utils.DatabaseUtil" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <title>Add Product</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Tailwind CSS -->
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <!-- Font Awesome -->
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

        .input-field, select, textarea {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 10px;
            width: 100%;
            background: var(--panel-color);
            color: var(--text-color);
            transition: border-color 0.2s;
        }

        .input-field:focus, select:focus, textarea:focus {
            border-color: #3b82f6;
            outline: none;
        }

        label {
            color: var(--black-light-color);
            font-weight: 500;
            display: block;
            margin-bottom: 0.5rem;
        }

        .btn {
            transition: transform 0.2s, background 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }
    </style>
    <script>
        function handleCategoryChange(select) {
            if (select.value === "add_new") {
                window.location.href = "admincategory.jsp";
            }
        }
        
        // Apply dark mode if enabled
        document.addEventListener('DOMContentLoaded', function() {
            if (localStorage.getItem("darkMode") === "enabled") {
                document.body.classList.add("dark");
            }
        });
    </script>
</head>
<body>
    <div class="p-6">
       

        <form action="AddProductServlet" method="post" enctype="multipart/form-data">
            <h2 class="text-2xl font-bold mb-6 text-center"><i class="fas fa-plus mr-2"></i>Add New Product</h2>

            <div class="mb-5">
                <label for="category">Category:</label>
                <select name="category" id="category" class="input-field" required onchange="handleCategoryChange(this)">
                    <option value="">-- Select Category --</option>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DatabaseUtil.getConnection();
                            Statement stmt = con.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM category");

                            while (rs.next()) {
                                int id = rs.getInt("CategoryID");
                                String desc = rs.getString("Description");
                    %>
                                <option value="<%= id %>"><%= id %> - <%= desc %></option>
                    <%
                            }
                            rs.close();
                            stmt.close();
                            con.close();
                        } catch (Exception e) {
                            out.println("<p class='text-red-600'>Error loading categories: " + e.getMessage() + "</p>");
                        }
                    %>
                    <option value="add_new">Add New Category</option>
                </select>
            </div>

            <div class="mb-5">
                <label for="name">Product Name:</label>
                <input type="text" name="name" id="name" class="input-field" required>
            </div>

            <div class="mb-5">
                <label for="price">Unit Price:</label>
                <input type="number" name="price" id="price" step="0.01" min="0.01" class="input-field" required>
            </div>

            <div class="mb-5">
                <label for="stock">Stock:</label>
                <input type="number" name="stock" id="stock" min="0" class="input-field" required>
            </div>

            <div class="mb-5">
                <label for="description">Description:</label>
                <textarea name="description" id="description" class="input-field" required></textarea>
            </div>

            <div class="mb-5">
                <label for="image">Upload Image:</label>
                <input type="file" name="image" id="image" accept="image/*" class="input-field" required>
            </div>

            <div class="flex justify-end">
                <button type="submit" class="bg-blue-600 text-white px-5 py-2.5 rounded-lg btn">
                    <i class="fas fa-save mr-2"></i>Add Product
                </button>
            </div>
        </form>
    </div>
</body>
</html>