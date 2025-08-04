<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.UserDAO, dao.ProductDAO, dao.OrderDAO" %>
<%
    // Security check - only allow admin access
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || !Boolean.TRUE.equals(sessionObj.getAttribute("isAdmin"))) {
        response.sendRedirect("index.jsp?error=unauthorized");
        return;
    }

    // Fetch counts from DAOs
    UserDAO userDAO = new UserDAO();
    ProductDAO productDAO = new ProductDAO();
    OrderDAO orderDAO = new OrderDAO();
    int userCount = 0;
    int productCount = 0;
    int orderCount = 0;
    try {
        userCount = userDAO.getAll().size();
        productCount = productDAO.getAll().size();
        orderCount = orderDAO.getAll().size();
    } catch (Exception e) {
        e.printStackTrace();
        // Optionally handle errors (e.g., display "N/A" or log error)
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
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

        /* Card styles */
        .card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 4px 20px var(--shadow-color);
            padding: 24px;
        }

        /* Dashboard boxes */
        .dashboard-boxes {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .dashboard-box {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 10px var(--shadow-color);
            text-align: center;
            transition: transform 0.3s ease, background 0.3s ease;
            cursor: pointer;
        }

        .dashboard-box:hover {
            transform: translateY(-5px);
        }

        .dashboard-box i {
            font-size: 2.5rem;
            color: #3b82f6;
            margin-bottom: 1rem;
        }

        body.dark .dashboard-box i {
            color: #60a5fa;
        }

        .dashboard-box .text {
            font-size: 1.2rem;
            font-weight: 500;
            color: var(--black-light-color);
            margin-bottom: 0.5rem;
        }

        .dashboard-box .number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--table-header-bg);
        }

        body.dark .dashboard-box .number {
            color: #3b82f6;
        }

        /* Heading styles */
        h1 {
            font-weight: 700;
            color: var(--table-header-bg);
        }

        body.dark h1 {
            color: #3b82f6;
        }
    </style>
</head>
<body>
    <%@ include file="adminheader.jsp" %>
    <div class="main-content">
        <div class="card">
            <h1 class="text-4xl font-bold mb-8 text-center"><i class="fas fa-tachometer-alt mr-3"></i>Dashboard</h1>
            <div class="dashboard-boxes">
                <div class="dashboard-box" onclick="navigateTo('user-management')">
                    <i class="fas fa-users"></i>
                    <span class="text">Users</span>
                    <span class="number"><%= userCount %></span>
                </div>
                <div class="dashboard-box" onclick="navigateTo('adminproduct.jsp')">
                    <i class="fas fa-box"></i>
                    <span class="text">Products</span>
                    <span class="number"><%= productCount %></span>
                </div>
                <div class="dashboard-box" onclick="#">
                    <i class="fas fa-shopping-bag"></i>
                    <span class="text">Orders</span>
                    <span class="number"><%= orderCount %></span>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Ensure dark mode is applied on page load
        if (localStorage.getItem("darkMode") === "enabled") {
            document.body.classList.add("dark");
        }

        // Navigate to the specified page
        function navigateTo(page) {
            window.location.href = page;
        }
    </script>
</body>
</html>