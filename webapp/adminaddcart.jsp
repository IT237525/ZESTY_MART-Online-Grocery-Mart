<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, java.util.List, java.util.ArrayList" %>
<%@ page import="dao.UserDAO, dao.CartDAO" %>
<%@ page import="model.AddToCart" %>
<%
    // Admin access control
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || !Boolean.TRUE.equals(sessionObj.getAttribute("isAdmin"))) {
        response.sendRedirect("index.jsp?error=unauthorized");
        return;
    }

    UserDAO userDAO = new UserDAO();
    CartDAO cartDAO = new CartDAO();
    List<User> users = userDAO.getAll();
    List<AddToCart> cartItems = new ArrayList<>();
    for (User user : users) {
        List<AddToCart> userCartItems = cartDAO.getByUserId(user.getUserId());
        cartItems.addAll(userCartItems);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Cart Management</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
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

        .cart-table th,
        .cart-table td {
            padding: 16px;
            text-align: center;
            word-wrap: break-word;
        }

        .cart-table th {
            background: var(--table-header-bg);
            color: white;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 10;
            cursor: pointer;
        }

        .cart-table th:hover {
            background: #1e40af;
        }

        .cart-table th.sort-asc::after {
            content: ' ↑';
            font-size: 0.8em;
        }

        .cart-table th.sort-desc::after {
            content: ' ↓';
            font-size: 0.8em;
        }

        .cart-table tr {
            transition: background 0.2s;
            background: var(--card-bg);
        }

        .cart-table tr:hover {
            background: var(--table-hover-bg);
        }

        .cart-table tr:nth-child(even) {
            background: var(--table-bg);
        }

        /* Button styles */
        .btn {
            transition: transform 0.2s, background 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            cursor: pointer;
            border-radius: 6px;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .delete-btn {
            background-color: #ef4444;
            color: #ffffff;
        }

        .delete-btn:hover {
            background-color: #dc2626;
        }

        .delete-btn:disabled {
            background-color: #fca5a5;
            cursor: not-allowed;
        }

        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .loading::after {
            content: '';
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid #ffffff;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin-left: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Input styles */
        .input-field {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 10px;
            width: 250px;
            background: var(--panel-color);
            color: var(--text-color);
            transition: border-color 0.2s;
        }

        .input-field:focus {
            border-color: #3b82f6;
            outline: none;
        }

        /* Checkbox styles */
        .cart-table input[type="checkbox"] {
            cursor: pointer;
            accent-color: #3b82f6;
        }

        body.dark .cart-table input[type="checkbox"] {
            accent-color: #60a5fa;
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

        /* Search container */
        .search-container {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="adminheader.jsp" %>
    <div class="main-content">
        <div class="card">
            <h1 class="text-4xl font-bold mb-8 text-center"><i class="fas fa-shopping-cart mr-3"></i>Cart Management</h1>

            <div class="search-container">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" class="input-field" placeholder="Search cart items...">
            </div>

            <div class="table-container">
                <table class="min-w-full rounded-lg cart-table">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="selectAll"></th>
                            <th>User ID</th>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Total</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (AddToCart item : cartItems) { %>
                            <tr id="cart-row-<%= item.getUserId() %>-<%= item.getProductId() %>">
                                <td><input type="checkbox" class="row-checkbox"></td>
                                <td><%= item.getUserId() %></td>
                                <td><%= item.getProductId() %></td>
                                <td><%= item.getProductName() %></td>
                                <td><%= item.getQuantity() %></td>
                                <td>Rs. <%= item.getUnitPrice() %></td>
                                <td>Rs. <%= item.getTotal() %></td>
                                <td>
                                    <button class="action-btn delete-btn btn" onclick="deleteCartItem(<%= item.getUserId() %>, <%= item.getProductId() %>)">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const table = document.querySelector('.cart-table');
            const tbody = table.querySelector('tbody');
            const headers = table.querySelectorAll('th');
            const searchInput = document.getElementById('searchInput');
            const selectAll = document.getElementById('selectAll');

            let sortColumn = 1; // Default sort by User ID
            let sortDirection = 1;

            // Sorting
            headers.forEach((header, index) => {
                if (index > 0 && index < headers.length - 1) { // Exclude Checkbox and Actions
                    header.addEventListener('click', () => {
                        const newDirection = sortColumn === index ? -sortDirection : 1;
                        sortTable(index, newDirection);
                        headers.forEach(h => h.classList.remove('sort-asc', 'sort-desc'));
                        header.classList.add(newDirection > 0 ? 'sort-asc' : 'sort-desc');
                        sortColumn = index;
                        sortDirection = newDirection;
                    });
                }
            });

            function sortTable(column, direction) {
                const rows = Array.from(tbody.querySelectorAll('tr'));
                rows.sort((a, b) => {
                    let aText = a.children[column].textContent.trim();
                    let bText = b.children[column].textContent.trim();
                    if (column === 1 || column === 2 || column === 4) { // UserID, ProductID, Quantity
                        aText = parseFloat(aText.replace(/[^0-9.-]+/g, '')) || 0;
                        bText = parseFloat(bText.replace(/[^0-9.-]+/g, '')) || 0;
                        return (aText - bText) * direction;
                    } else if (column === 5 || column === 6) { // Unit Price, Total
                        aText = parseFloat(aText.replace(/[^0-9.-]+/g, '')) || 0;
                        bText = parseFloat(bText.replace(/[^0-9.-]+/g, '')) || 0;
                        return (aText - bText) * direction;
                    }
                    return aText.localeCompare(bText) * direction;
                });
                tbody.innerHTML = '';
                rows.forEach(row => tbody.appendChild(row));
            }

            // Search
            searchInput.addEventListener('input', () => {
                const query = searchInput.value.toLowerCase();
                const rows = tbody.querySelectorAll('tr');
                rows.forEach(row => {
                    const text = Array.from(row.children)
                        .slice(1, -1) // Exclude Checkbox and Actions
                        .map(cell => cell.textContent.toLowerCase())
                        .join(' ');
                    row.style.display = text.includes(query) ? '' : 'none';
                });
            });

            // Select All Checkbox
            selectAll.addEventListener('change', () => {
                const checkboxes = tbody.querySelectorAll('.row-checkbox');
                checkboxes.forEach(cb => cb.checked = selectAll.checked);
            });

            // Ensure dark mode is applied on page load
            if (localStorage.getItem("darkMode") === "enabled") {
                document.body.classList.add("dark");
            }
        });

        function deleteCartItem(userId, productId) {
            if (!confirm("Are you sure you want to delete this cart item?")) return;

            const button = document.querySelector(`#cart-row-${userId}-${productId} .delete-btn`);
            button.classList.add('loading');
            button.disabled = true;

            fetch("admin/cart-management", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: `action=deleteCartItem&userId=${userId}&productId=${productId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === "success") {
                    const row = document.getElementById(`cart-row-${userId}-${productId}`);
                    row.style.transition = 'opacity 0.3s ease';
                    row.style.opacity = '0';
                    setTimeout(() => row.remove(), 300);
                    alert("Cart item deleted successfully!");
                } else {
                    alert("Failed to delete cart item: " + (data.message || "Unknown error"));
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("An error occurred while deleting the cart item.");
            })
            .finally(() => {
                button.classList.remove('loading');
                button.disabled = false;
            });
        }
    </script>
</body>
</html>