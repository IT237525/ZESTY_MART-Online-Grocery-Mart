<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.CategoryDAO, model.Category, java.util.List" %>
<%
    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("isAdmin") == null || !Boolean.TRUE.equals(sessionObj.getAttribute("isAdmin"))) {
        response.sendRedirect("index.jsp?error=unauthorized");
        return;
    }

    CategoryDAO categoryDAO = new CategoryDAO();
    List<Category> categories = null;
    try {
        categories = categoryDAO.getAll();
    } catch (java.sql.SQLException e) {
        request.setAttribute("error", "Failed to load categories: " + e.getMessage());
    }
    String message = request.getParameter("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Category Management</title>
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
            margin: 10% auto;
            padding: 24px;
            width: 90%;
            max-width: 500px;
            border-radius: 12px;
            position: relative;
            box-shadow: 0 10px 30px var(--shadow-color);
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

        .category-table th,
        .category-table td {
            padding: 16px;
            text-align: center;
            word-wrap: break-word;
        }

        .category-table th {
            background: var(--table-header-bg);
            color: white;
            font-weight: 600;
        }

        .category-table tr {
            transition: background 0.2s;
            background: var(--card-bg);
        }

        .category-table tr:hover {
            background: var(--table-hover-bg);
        }

        .category-table tr:nth-child(even) {
            background: var(--table-bg);
        }

        /* Button styles */
        .btn {
            transition: transform 0.2s, background 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
            background: #1e40af;
        }

        /* Input styles */
        .input-field {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 10px;
            width: 100%;
            background: var(--panel-color);
            color: var(--text-color);
            transition: border-color 0.2s;
        }

        .input-field:focus {
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
            <h1 class="text-4xl font-bold mb-8 text-center"><i class="fas fa-tags mr-3"></i>Category Management</h1>

            <% if (message != null) { %>
                <div class="<%= message.startsWith("Error") ? "error" : "message" %>">
                    <%= message %>
                </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>

            <!-- Add Category Button -->
            <div class="mb-6 text-center">
                <button onclick="showPopup('add')" class="bg-blue-600 text-white px-5 py-2.5 rounded-lg btn"><i class="fas fa-plus mr-2"></i>Add Category</button>
            </div>

            <!-- Category Table -->
            <div class="table-container">
                <table class="min-w-full rounded-lg category-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Description</th>
                            <th>Image</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (categories != null && !categories.isEmpty()) { %>
                            <% int counter = 1; %>
                            <% for (Category category : categories) { %>
                                <tr>
                                    <td><%= counter++ %></td>
                                    <td><%= category.getDescription() %></td>
                                    <td>
                                        <% if (category.getImage() != null) { %>
                                            <img src="<%= request.getContextPath() + "/" + category.getImage() %>" alt="<%= category.getDescription() %>" class="w-12 h-12 rounded-lg object-cover">
                                        <% } else { %>
                                            <span class="text-muted">No Image</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <button class="bg-yellow-500 text-white px-4 py-2 rounded-lg btn" onclick="showPopup('edit', <%= category.getCategoryId() %>, '<%= java.net.URLEncoder.encode(category.getDescription(), "UTF-8").replace("+", " ") %>', '<%= category.getImage() != null ? java.net.URLEncoder.encode(category.getImage(), "UTF-8").replace("+", " ") : "" %>')">
                                            <i class="fas fa-edit mr-2"></i>Edit
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr><td colspan="4" class="text-center">No categories found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Popup Form -->
        <div class="popup" id="popupForm">
            <div class="popup-content">
                <button class="close-btn" onclick="closePopup()"><i class="fas fa-times"></i></button>
                <h2 class="text-2xl font-bold mb-6" id="popupTitle"><i class="fas fa-tags mr-2"></i>Category</h2>
                <form id="categoryForm" action="CategoryServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                    <input type="hidden" name="action" id="formAction">
                    <input type="hidden" name="categoryId" id="categoryId">
                    <input type="hidden" name="existingImage" id="existingImage">
                    <div class="mb-5">
                        <label class="block mb-2">Description</label>
                        <input type="text" id="description" name="description" class="input-field" required>
                    </div>
                    <div class="mb-5">
                        <label class="block mb-2">Image</label>
                        <input type="file" id="image" name="image" class="input-field" accept="image/jpeg,image/png,image/gif">
                    </div>
                    <div class="flex justify-between">
                        <button type="button" class="bg-red-600 text-white px-4 py-2 rounded-lg btn" id="deleteBtn" style="display:none;" onclick="deleteCategory()"><i class="fas fa-trash mr-2"></i>Delete</button>
                        <button type="submit" class="bg-green-600 text-white px-4 py-2 rounded-lg btn" id="submitBtn"><i class="fas fa-save mr-2"></i>Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function showPopup(action, categoryId = '', description = '', image = '') {
            const popup = document.getElementById('popupForm');
            const form = document.getElementById('categoryForm');
            const formAction = document.getElementById('formAction');
            const categoryIdInput = document.getElementById('categoryId');
            const descriptionInput = document.getElementById('description');
            const existingImageInput = document.getElementById('existingImage');
            const popupTitle = document.getElementById('popupTitle');
            const submitBtn = document.getElementById('submitBtn');
            const deleteBtn = document.getElementById('deleteBtn');

            popup.style.display = 'block';

            if (action === 'add') {
                popupTitle.innerHTML = '<i class="fas fa-plus-circle mr-2"></i>Add New Category';
                formAction.value = 'add';
                categoryIdInput.value = '';
                descriptionInput.value = '';
                existingImageInput.value = '';
                submitBtn.innerHTML = '<i class="fas fa-plus mr-2"></i>Add';
                deleteBtn.style.display = 'none';
            } else {
                popupTitle.innerHTML = '<i class="fas fa-edit mr-2"></i>Edit Category';
                formAction.value = 'edit';
                categoryIdInput.value = categoryId;
                descriptionInput.value = decodeURIComponent(description);
                existingImageInput.value = decodeURIComponent(image);
                submitBtn.innerHTML = '<i class="fas fa-save mr-2"></i>Update';
                deleteBtn.style.display = 'inline-block';
            }
        }

        function closePopup() {
            document.getElementById('popupForm').style.display = 'none';
        }

        function deleteCategory() {
            if (confirm('Are you sure you want to delete this category?')) {
                const form = document.getElementById('categoryForm');
                form.action = 'CategoryServlet';
                form.querySelector('#formAction').value = 'delete';
                form.submit();
            }
        }

        function validateForm() {
            const fileInput = document.getElementById('image');
            if (fileInput.files.length > 0) {
                const fileSize = fileInput.files[0].size; // in bytes
                const maxSize = 5 * 1024 * 1024; // 5MB
                if (fileSize > maxSize) {
                    alert('File size exceeds 5MB limit.');
                    return false;
                }
            }
            return true;
        }


        // Ensure dark mode is applied on page load
        if (localStorage.getItem("darkMode") === "enabled") {
            document.body.classList.add("dark");
        }
    </script>
</body>
</html>