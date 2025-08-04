<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
    // Security check - only allow admin access
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || !Boolean.TRUE.equals(sessionObj.getAttribute("isAdmin"))) {
        response.sendRedirect("index.jsp?error=unauthorized");
        return;
    }

  
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Notifications</title>
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
            max-width: 960px;
            border-radius: 12px;
            position: relative;
            max-height: 85vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px var(--shadow-color);
        }

        .popup-content::-webkit-scrollbar,
        .table-container::-webkit-scrollbar {
            display: none;
        }

        .popup-content,
        .table-container {
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

        .notification-table th,
        .notification-table td {
            padding: 16px;
            text-align: left;
            word-wrap: break-word;
            max-width: 220px;
        }

        .notification-table th {
            background: var(--table-header-bg);
            color: white;
            font-weight: 600;
        }

        .notification-table tr {
            transition: background 0.2s;
            background: var(--card-bg);
        }

        .notification-table tr:hover {
            background: var(--table-hover-bg);
        }

        .notification-table tr:nth-child(even) {
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

        /* Input and textarea styles */
        .input-field,
        .textarea-field {
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 10px;
            width: 100%;
            background: var(--panel-color);
            color: var(--text-color);
            transition: border-color 0.2s;
        }

        .input-field:focus,
        .textarea-field:focus {
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
        h1, h2 {
            font-weight: 700;
            color: var(--table-header-bg);
        }

        body.dark h1,
        body.dark h2 {
            color: #3b82f6;
        }

        label {
            color: var(--black-light-color);
            font-weight: 500;
        }
    </style>
</head>
<body class="bg-gray-50">
    <%@ include file="adminheader.jsp" %>
    <div class="main-content">
        <div class="card">
            <h1 class="text-4xl font-bold mb-8 text-center"><i class="fas fa-bell mr-3"></i>Admin Notification Management</h1>

            <!-- Add Notification Button -->
            <div class="mb-6 flex justify-between items-center">
                <button onclick="openAddPopup()" class="bg-blue-600 text-white px-5 py-2.5 rounded-lg btn"><i class="fas fa-plus mr-2"></i>Add Notification</button>
                <form action="NotificationServlet" method="get" class="flex items-center">
                    <input type="text" name="searchUserId" placeholder="Search by User ID" class="input-field w-72 mr-2">
                    <button type="submit" class="bg-gray-600 text-white px-5 py-2.5 rounded-lg btn"><i class="fas fa-search"></i></button>
                </form>
            </div>

            <!-- Add Notification Popup -->
            <div id="addPopup" class="popup">
                <div class="popup-content">
                    <button class="close-btn" onclick="closeAddPopup()"><i class="fas fa-times"></i></button>
                    <h2 class="text-2xl font-bold mb-6"><i class="fas fa-plus-circle mr-2"></i>Add New Notification</h2>
                    <form action="NotificationServlet" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-5">
                            <label class="block mb-2">Select User(s)</label>
                            <select name="userIds" multiple class="input-field" size="5">
                                <option value="all">All Users</option>
                                <%
                                    UserDAO userDAO = new UserDAO();
                                    List<User> users = userDAO.getAll();
                                    for (User user : users) {
                                %>
                                    <option value="<%= user.getUserId() %>"><%= user.getUserId() %> - <%= user.getFirstName() %> <%= user.getLastName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-5">
                            <label class="block mb-2">Subject</label>
                            <input type="text" name="subject" class="input-field" required>
                        </div>
                        <div class="mb-5">
                            <label class="block mb-2">Message</label>
                            <textarea name="message" class="textarea-field" rows="4" required></textarea>
                        </div>
                        <div class="flex justify-end">
                            <button type="submit" class="bg-green-600 text-white px-5 py-2.5 rounded-lg btn"><i class="fas fa-paper-plane mr-2"></i>Post Notification</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Notifications Table -->
            <div class="table-container">
                <table class="min-w-full rounded-lg notification-table">
                    <thead>
                        <tr>
                            <th class="py-3 px-6">User ID</th>
                            <th class="py-3 px-6">First Name</th>
                            <th class="py-3 px-6">Last Name</th>
                            <th class="py-3 px-6">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<User> userList = (List<User>) request.getAttribute("users");
                            if (userList == null) {
                                userList = userDAO.getAll();
                            }
                            for (User user : userList) {
                        %>
                            <tr class="border-b border-gray-200">
                                <td class="py-3 px-6 text-center"><%= user.getUserId() %></td>
                                <td class="py-3 px-6 text-center"><%= user.getFirstName() %></td>
                                <td class="py-3 px-6 text-center"><%= user.getLastName() %></td>
                                <td class="py-3 px-6 text-center">
                                    <form action="NotificationServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="show">
                                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                        <button type="submit" class="bg-yellow-500 text-white px-4 py-2 rounded-lg btn"><i class="fas fa-eye mr-2"></i>Show Messages</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Show Messages/Update Popup -->
        <div id="showPopup" class="popup" style="display: <%= request.getAttribute("notifications") != null || request.getAttribute("editNotification") != null ? "block" : "none" %>;">
            <div class="popup-content">
                <button class="close-btn" onclick="closeShowPopup()"><i class="fas fa-times"></i></button>
                <% 
                    Notification editNotification = (Notification) request.getAttribute("editNotification");
                    if (editNotification != null) {
                %>
                    <h2 class="text-2xl font-bold mb-6"><i class="fas fa-edit mr-2"></i>Edit Notification</h2>
                    <form action="NotificationServlet" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="notificationId" value="<%= editNotification.getNotificationId() %>">
                        <input type="hidden" name="userId" value="<%= editNotification.getUserId() %>">
                        <div class="mb-5">
                            <label class="block mb-2">Subject</label>
                            <input type="text" name="subject" value="<%= editNotification.getSubject() %>" class="input-field" required>
                        </div>
                        <div class="mb-5">
                            <label class="block mb-2">Message</label>
                            <textarea name="message" class="textarea-field" rows="4" required><%= editNotification.getMessage() %></textarea>
                        </div>
                        <div class="flex justify-end">
                            <button type="submit" class="bg-green-600 text-white px-5 py-2.5 rounded-lg btn"><i class="fas fa-save mr-2"></i>Update</button>
                        </div>
                    </form>
                <% } else { %>
                    <h2 class="text-2xl font-bold mb-6"><i class="fas fa-envelope mr-2"></i>User Notifications</h2>
                    <div class="table-container">
                        <table class="min-w-full notification-table">
                            <thead>
                                <tr>
                                    <th class="py-3 px-6">Notification ID</th>
                                    <th class="py-3 px-6">Subject</th>
                                    <th class="py-3 px-6">Message</th>
                                    <th class="py-3 px-6">Created At</th>
                                    <th class="py-3 px-6">Read Status</th>
                                    <th class="py-3 px-6">Status</th>
                                    <th class="py-3 px-6">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                                    if (notifications != null) {
                                        for (Notification n : notifications) {
                                %>
                                    <tr>
                                        <td class="py-3 px-6"><%= n.getNotificationId() %></td>
                                        <td class="py-3 px-6"><%= n.getSubject() %></td>
                                        <td class="py-3 px-6"><%= n.getMessage() %></td>
                                        <td class="py-3 px-6"><%= n.getCreatedAt() %></td>
                                        <td class="py-3 px-6"><%= n.isRead() ? "Read" : "Unread" %></td>
                                        <td class="py-3 px-6"><%= n.isDeletedByUser() ? "Deleted" : "Active" %></td>
                                        <td class="py-3 px-6">
                                            <form action="NotificationServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="edit">
                                                <input type="hidden" name="notificationId" value="<%= n.getNotificationId() %>">
                                                <input type="hidden" name="userId" value="<%= n.getUserId() %>">
                                                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg btn"><i class="fas fa-edit mr-2"></i>Update</button>
                                            </form>
                                            <form action="NotificationServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="notificationId" value="<%= n.getNotificationId() %>">
                                                <input type="hidden" name="userId" value="<%= n.getUserId() %>">
                                                <button type="submit" onclick="return confirm('Are you sure you want to delete this notification?')" class="bg-red-600 text-white px-4 py-2 rounded-lg btn"><i class="fas fa-trash mr-2"></i>Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                <% 
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function openAddPopup() {
            document.getElementById('addPopup').style.display = 'block';
        }

        function closeAddPopup() {
            document.getElementById('addPopup').style.display = 'none';
        }

        function closeShowPopup() {
            document.getElementById('showPopup').style.display = 'none';
            window.location.href = 'NotificationServlet';
        }
    </script>
</body>
</html>