<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.DeletedUser, java.util.List" %>
<%
    // Security check - only allow admin access
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || !Boolean.TRUE.equals(sessionObj.getAttribute("isAdmin"))) {
        response.sendRedirect("index.jsp?error=unauthorized");
        return;
    }

    // Get data from request attributes
    List<User> activeUsers = (List<User>) request.getAttribute("activeUsers");
    List<DeletedUser> deletedUsers = (List<DeletedUser>) request.getAttribute("deletedUsers");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - User Management</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            min-height: 100vh;
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

        /* Table styles */
        .table-container {
            max-height: 60vh;
            overflow-y: auto;
            border-radius: 8px;
            display: none; /* Hidden by default */
        }

        .table-container.active {
            display: block;
        }

        .table-container::-webkit-scrollbar {
            display: none;
        }

        .table-container {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        .user-table th,
        .user-table td {
            padding: 16px;
            text-align: left;
            word-wrap: break-word;
            max-width: 220px;
        }

        .user-table th {
            background: var(--table-header-bg);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        .user-table tr {
            transition: background 0.2s;
            background: var(--card-bg);
        }

        .user-table tr:hover {
            background: var(--table-hover-bg);
        }

        .user-table tr:nth-child(even) {
            background: var(--table-bg);
        }

        .profile-img-table {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 50%;
            vertical-align: middle;
        }

        /* Card grid styles */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }

        .user-card-container {
            display: block; /* Shown by default */
        }

        .user-card-container.active {
            display: block;
        }

        .user-card-container.hidden {
            display: none;
        }

        .user-card {
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 6px 12px var(--shadow-color);
            padding: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px var(--shadow-color);
        }

        .user-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #3b82f6, #00c4b4);
        }

        .deleted-card::before {
            background: linear-gradient(90deg, #dc3545, #ff6b6b);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .card-body {
            display: flex;
            flex-direction: column;
            gap: 12px;
            align-items: center; /* Center content for better aesthetics */
            padding: 10px 0;
        }

        .card-body .info {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            color: var(--black-light-color);
            width: 100%;
            justify-content: center;
        }

        .card-body .info i {
            color: #3b82f6;
        }

        .card-footer {
            margin-top: 15px;
            text-align: right;
            width: 100%;
        }

        .profile-img-card {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px; /* Square with slight rounding */
            border: 3px solid #3b82f6;
            box-shadow: 0 4px 8px var(--shadow-color);
            margin-bottom: 12px;
        }

        /* Button styles */
        .btn {
            transition: transform 0.2s, background 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
            background: #1e40af;
        }

        .action-btn {
            padding: 6px 12px;
            font-size: 0.875rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px var(--shadow-color);
            display: inline-flex;
            align-items: center;
            transition: transform 0.2s, background 0.2s, box-shadow 0.2s;
        }

        .action-btn i {
            margin-right: 6px;
            font-size: 0.9rem;
        }

        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px var(--shadow-color);
        }

        .action-btn.delete {
            background: #dc2626;
            color: white;
        }

        .action-btn.restore {
            background: #16a34a;
            color: white;
        }

        .action-btn.delete:hover {
            background: #b91c1c;
        }

        .action-btn.restore:hover {
            background: #15803d;
        }

        /* Input and textarea styles */
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

        /* Heading styles */
        h1 {
            font-weight: 700;
            color: var(--table-header-bg);
        }

        body.dark h1 {
            color: #3b82f6;
        }

        /* Alert styles */
        .alert {
            background: var(--table-bg);
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
            box-shadow: 0 2px 4px var(--shadow-color);
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border-color: #f87171;
        }

        body.dark .alert-error {
            background: #7f1d1d;
            color: #f87171;
            border-color: #991b1b;
        }

        /* Tabs styles */
        .tabs {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }

        .tab {
            padding: 12px 24px;
            cursor: pointer;
            background: var(--panel-color);
            border-radius: 8px;
            font-weight: 500;
            color: var(--black-light-color);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .tab.active {
            background: #2563eb;
            color: white;
        }

        .tab:hover {
            background: var(--table-hover-bg);
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        /* Toggle switch styles */
        .view-toggle {
            margin: 15px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .toggle-label {
            font-size: 16px;
            color: var(--text-color);
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 60px;
            height: 34px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: var(--toggle-color);
            transition: 0.4s;
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 26px;
            width: 26px;
            left: 4px;
            bottom: 4px;
            background: var(--panel-color);
            transition: 0.4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background: #3b82f6;
        }

        input:checked + .slider:before {
            transform: translateX(26px);
        }
    </style>
</head>
<body class="bg-gray-50">
    <%@ include file="adminheader.jsp" %>
    <div class="main-content">
        <div class="card">
            <h1 class="text-4xl font-bold mb-8 text-center"><i class="fas fa-users mr-3"></i>User Management</h1>

            <!-- Error Message -->
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle mr-2"></i><%= error %>
                </div>
            <% } %>

            <!-- Search Bar -->
            <div class="mb-6 flex justify-between items-center">
                <div></div> <!-- Empty div for spacing -->
                <form action="<%= request.getContextPath() %>/user-management" method="get" class="flex items-center">
                    <input type="text" name="userId" placeholder="Search by User ID" value="<%= request.getParameter("userId") != null ? request.getParameter("userId") : "" %>" class="input-field w-72 mr-2">
                    <button type="submit" class="bg-gray-600 text-white px-5 py-2.5 rounded-lg btn">
                        <i class="fas fa-search"></i>
                    </button>
                </form>
            </div>

            <!-- Tabs -->
            <div class="tabs">
                <div class="tab active" onclick="showTab('active-users')">Active Users</div>
                <div class="tab" onclick="showTab('deleted-users')">Deleted Users</div>
            </div>

            <!-- View Toggle -->
            <div class="view-toggle">
                <span class="toggle-label">Card View</span>
                <label class="toggle-switch">
                    <input type="checkbox" onchange="toggleView(this.checked)">
                    <span class="slider"></span>
                </label>
                <span class="toggle-label">Table View</span>
            </div>

            <!-- Active Users Tab -->
            <div id="active-users" class="tab-content active">
                <!-- Table View -->
                <div class="table-container">
                    <table class="min-w-full rounded-lg user-table">
                        <thead>
                            <tr>
                                <th class="py-3 px-6">Profile Image</th>
                                <th class="py-3 px-6">ID</th>
                                <th class="py-3 px-6">First</th>
                                <th class="py-3 px-6">Last</th>
                                <th class="py-3 px-6">Gender</th>
                                <th class="py-3 px-6">Phone</th>
                                <th class="py-3 px-6">Address</th>
                                <th class="py-3 px-6">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (activeUsers != null && !activeUsers.isEmpty()) {
                                    for (User user : activeUsers) {
                            %>
                                <tr id="row-<%= user.getUserId() %>" class="border-b border-gray-200">
                                    <td class="py-3 px-6">
                                        <% if (user.getProfileImageBase64() != null) { %>
                                            <img src="<%= user.getProfileImageBase64() %>" class="profile-img-table" alt="Profile Image">
                                        <% } else { %>
                                            <span>No Image</span>
                                        <% } %>
                                    </td>
                                    <td class="py-3 px-6"><%= user.getUserId() %></td>
                                    <td class="py-3 px-6"><%= user.getFirstName() != null ? user.getFirstName() : "" %></td>
                                    <td class="py-3 px-6"><%= user.getLastName() != null ? user.getLastName() : "" %></td>
                                    <td class="py-3 px-6"><%= user.getGender() != null ? user.getGender() : "" %></td>
                                    <td class="py-3 px-6"><%= user.getPhone() != null ? user.getPhone() : "" %></td>
                                    <td class="py-3 px-6"><%= user.getAddress() != null ? user.getAddress() : "" %></td>
                                    <td class="py-3 px-6">
                                        <button class="action-btn delete" onclick="deleteUser(<%= user.getUserId() %>)">
                                            <i class="fas fa-trash"></i>Delete
                                        </button>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="8" class="py-10 text-center">
                                        <i class="fas fa-users fa-3x text-gray-400 mb-3"></i>
                                        <h5 class="text-gray-500">No active users found</h5>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <!-- Card View -->
                <div class="user-card-container active">
                    <div class="card-grid">
                        <% 
                            if (activeUsers != null && !activeUsers.isEmpty()) {
                                for (User user : activeUsers) {
                        %>
                            <div class="user-card" id="card-<%= user.getUserId() %>">
                                <div class="card-header">
                                    <span class="user-id">ID: <%= user.getUserId() %></span>
                                </div>
                                <div class="card-body">
                                    <% if (user.getProfileImageBase64() != null) { %>
                                        <img src="<%= user.getProfileImageBase64() %>" class="profile-img-card" alt="Profile Image">
                                    <% } else { %>
                                        <span class="text-gray-500">No Image</span>
                                    <% } %>
                                    <div class="info"><i class="fas fa-user"></i> <span><%= user.getFirstName() != null ? user.getFirstName() : "" %> <%= user.getLastName() != null ? user.getLastName() : "" %></span></div>
                                    <div class="info"><i class="fas fa-venus-mars"></i> <span><%= user.getGender() != null ? user.getGender() : "" %></span></div>
                                    <div class="info"><i class="fas fa-phone"></i> <span><%= user.getPhone() != null ? user.getPhone() : "" %></span></div>
                                    <div class="info"><i class="fas fa-map-marker-alt"></i> <span><%= user.getAddress() != null ? user.getAddress() : "" %></span></div>
                                </div>
                                <div class="card-footer">
                                    <button class="action-btn delete" onclick="deleteUser(<%= user.getUserId() %>)">
                                        <i class="fas fa-trash"></i>Delete
                                    </button>
                                </div>
                            </div>
                        <% 
                                }
                            } else {
                        %>
                            <div class="py-10 text-center">
                                <i class="fas fa-users fa-3x text-gray-400 mb-3"></i>
                                <h5 class="text-gray-500">No active users found</h5>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Deleted Users Tab -->
            <div id="deleted-users" class="tab-content">
                <!-- Table View -->
                <div class="table-container">
                    <table class="min-w-full rounded-lg user-table">
                        <thead>
                            <tr>
                                <th class="py-3 px-6">Profile Image</th>
                                <th class="py-3 px-6">Deleted ID</th>
                                <th class="py-3 px-6">User ID</th>
                                <th class="py-3 px-6">First</th>
                                <th class="py-3 px-6">Last</th>
                                <th class="py-3 px-6">Gender</th>
                                <th class="py-3 px-6">Phone</th>
                                <th class="py-3 px-6">Address</th>
                                <th class="py-3 px-6">Deletion Date</th>
                                <th class="py-3 px-6">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                if (deletedUsers != null && !deletedUsers.isEmpty()) {
                                    for (DeletedUser deletedUser : deletedUsers) {
                            %>
                                <tr id="deleted-row-<%= deletedUser.getDeletedUserId() %>" class="border-b border-gray-200">
                                    <td class="py-3 px-6">
                                        <% if (deletedUser.getProfileImageBase64() != null) { %>
                                            <img src="<%= deletedUser.getProfileImageBase64() %>" class="profile-img-table" alt="Profile Image">
                                        <% } else { %>
                                            <span>No Image</span>
                                        <% } %>
                                    </td>
                                    <td class="py-3 px-6"><%= deletedUser.getDeletedUserId() %></td>
                                    <td class="py-3 px-6"><%= deletedUser.getUserId() %></td>
                                    <td class="py-3 px-6"><%= deletedUser.getFirstName() != null ? deletedUser.getFirstName() : "" %></td>
                                    <td class="py-3 px-6"><%= deletedUser.getLastName() != null ? deletedUser.getLastName() : "" %></td>
                                    <td class="py-3 px-6"><%= deletedUser.getGender() != null ? deletedUser.getGender() : "" %></td>
                                    <td class="py-3 px-6"><%= deletedUser.getPhone() != null ? deletedUser.getPhone() : "" %></td>
                                    <td class="py-3 px-6"><%= deletedUser.getAddress() != null ? deletedUser.getAddress() : "" %></td>
                                    <td class="py-3 px-6"><%= deletedUser.getDeletionDate() != null ? deletedUser.getDeletionDate() : "" %></td>
                                    <td class="py-3 px-6">
                                        <button class="action-btn restore" onclick="restoreUser(<%= deletedUser.getDeletedUserId() %>)">
                                            <i class="fas fa-undo"></i>Restore
                                        </button>
                                    </td>
                                </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="10" class="py-10 text-center">
                                        <i class="fas fa-users fa-3x text-gray-400 mb-3"></i>
                                        <h5 class="text-gray-500">No deleted users found</h5>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <!-- Card View -->
                <div class="user-card-container active">
                    <div class="card-grid">
                        <% 
                            if (deletedUsers != null && !deletedUsers.isEmpty()) {
                                for (DeletedUser deletedUser : deletedUsers) {
                        %>
                            <div class="user-card deleted-card" id="deleted-card-<%= deletedUser.getDeletedUserId() %>">
                                <div class="card-header">
                                    <span class="user-id">Deleted ID: <%= deletedUser.getDeletedUserId() %></span>
                                    <span>User ID: <%= deletedUser.getUserId() %></span>
                                </div>
                                <div class="card-body">
                                    <% if (deletedUser.getProfileImageBase64() != null) { %>
                                        <img src="<%= deletedUser.getProfileImageBase64() %>" class="profile-img-card" alt="Profile Image">
                                    <% } else { %>
                                        <span class="text-gray-500">No Image</span>
                                    <% } %>
                                    <div class="info"><i class="fas fa-user"></i> <span><%= deletedUser.getFirstName() != null ? deletedUser.getFirstName() : "" %> <%= deletedUser.getLastName() != null ? deletedUser.getLastName() : "" %></span></div>
                                    <div class="info"><i class="fas fa-venus-mars"></i> <span><%= deletedUser.getGender() != null ? deletedUser.getGender() : "" %></span></div>
                                    <div class="info"><i class="fas fa-phone"></i> <span><%= deletedUser.getPhone() != null ? deletedUser.getPhone() : "" %></span></div>
                                    <div class="info"><i class="fas fa-map-marker-alt"></i> <span><%= deletedUser.getAddress() != null ? deletedUser.getAddress() : "" %></span></div>
                                    <div class="info"><i class="fas fa-calendar-times"></i> <span><%= deletedUser.getDeletionDate() != null ? deletedUser.getDeletionDate() : "" %></span></div>
                                </div>
                                <div class="card-footer">
                                    <button class="action-btn restore" onclick="restoreUser(<%= deletedUser.getDeletedUserId() %>)">
                                        <i class="fas fa-undo"></i>Restore
                                    </button>
                                </div>
                            </div>
                        <% 
                                }
                            } else {
                        %>
                            <div class="py-10 text-center">
                                <i class="fas fa-users fa-3x text-gray-400 mb-3"></i>
                                <h5 class="text-gray-500">No deleted users found</h5>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function deleteUser(userId) {
            if (!confirm("Are you sure you want to delete this user?")) return;

            const url = "<%= request.getContextPath() %>/user-management";
            fetch(url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "action=delete&userId=" + userId
            })
            .then(response => {
                if (!response.ok) throw new Error("HTTP error " + response.status);
                return response.json();
            })
            .then(data => {
                if (data.status === "success") {
                    document.getElementById("row-" + userId)?.remove();
                    document.getElementById("card-" + userId)?.remove();
                    alert(data.message);
                    location.reload();
                } else {
                    alert("Error: " + data.message);
                }
            })
            .catch(error => {
                alert("An error occurred: " + error.message);
            });
        }

        function restoreUser(deletedUserId) {
            if (!confirm("Are you sure you want to restore this user?")) return;

            const url = "<%= request.getContextPath() %>/user-management";
            fetch(url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "action=restore&deletedUserId=" + deletedUserId
            })
            .then(response => {
                if (!response.ok) throw new Error("HTTP error " + response.status);
                return response.json();
            })
            .then(data => {
                if (data.status === "success") {
                    document.getElementById("deleted-row-" + deletedUserId)?.remove();
                    document.getElementById("deleted-card-" + deletedUserId)?.remove();
                    alert(data.message);
                    location.reload();
                } else {
                    alert("Error: " + data.message);
                }
            })
            .catch(error => {
                alert("An error occurred: " + error.message);
            });
        }

        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
            document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
            document.querySelector(`.tab[onclick="showTab('${tabId}')"]`).classList.add('active');

            // Ensure correct view is displayed when switching tabs
            const isTableView = document.querySelector('.toggle-switch input').checked;
            toggleView(isTableView);
        }

        function toggleView(isTableView) {
            const tableContainers = document.querySelectorAll('.table-container');
            const cardContainers = document.querySelectorAll('.user-card-container');
            
            tableContainers.forEach(container => {
                container.style.display = isTableView ? 'block' : 'none';
                container.classList.toggle('active', isTableView);
                container.classList.toggle('hidden', !isTableView);
            });
            
            cardContainers.forEach(container => {
                container.style.display = isTableView ? 'none' : 'block';
                container.classList.toggle('active', !isTableView);
                container.classList.toggle('hidden', isTableView);
            });
        }

        window.onload = () => {
            showTab('active-users');
            toggleView(false); // Default to card view
        };
    </script>
</body>
</html>