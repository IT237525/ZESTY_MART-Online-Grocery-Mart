<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZestyMart</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        .zm-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: #fff;
            padding: 1.5rem 9%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            z-index: 1000;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }

        .zm-logo {
            font-size: 2.5rem;
            font-weight: 600;
            color: #222;
            text-decoration: none;
        }

        .zm-logo i {
            color: #bac34e;
        }

        .zm-navbar {
            display: flex;
            gap: 2rem;
        }

        .zm-nav-link {
            font-size: 1.7rem;
            color: #666;
            text-decoration: none;
            transition: color 0.3s;
        }

        .zm-nav-link:hover {
            color: #bac34e;
        }

        .zm-icons-container {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            position: relative;
        }

        .zm-icon-btn {
            font-size: 2.2rem;
            color: #666;
            cursor: pointer;
            background: none;
            border: none;
            position: relative;
            text-decoration: none;
        }

        .zm-icon-btn:hover {
            color: #bac34e;
        }

        .zm-cart-count {
            position: absolute;
            top: -8px;
            right: -10px;
            background: #dc3545;
            color: white;
            font-size: 0.75rem;
            padding: 2px 6px;
            border-radius: 50%;
        }

        .zm-dropdown-panel {
            position: absolute;
            top: 100%;
            right: 0;
            background: #fff;
            width: 350px;
            max-width: 90vw;
            max-height: 500px;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            display: none;
            z-index: 2000;
            animation: zmFadeIn 0.3s ease;
            overflow-y: auto;
        }

        .zm-dropdown-panel.active {
            display: block;
        }

        @keyframes zmFadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .zm-dropdown-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .zm-dropdown-header h3 {
            font-size: 1.2rem;
        }

        .zm-close-btn {
            font-size: 1.2rem;
            background: none;
            border: none;
            cursor: pointer;
            color: #999;
        }

        .notification-item {
            padding: 12px 15px;
            border-bottom: 1px solid #f5f5f5;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .notification-item:hover {
            background-color: #f8f9fa;
        }

        .notification-item.unread {
            background-color: #e6f3ff;
            font-weight: 500;
        }

        .notification-item h4 {
            margin: 0 0 5px 0;
            font-size: 1rem;
            color: #2c3e50;
        }

        .notification-item p {
            margin: 5px 0;
            font-size: 0.9rem;
            color: #666;
            display: none;
        }

        .notification-item p.expanded {
            display: block;
        }

        .notification-item small {
            font-size: 0.8rem;
            color: #999;
        }

        .notification-actions {
            margin-top: 8px;
            display: none;
            justify-content: flex-end;
        }

        .notification-item:hover .notification-actions,
        .notification-item.expanded .notification-actions {
            display: flex;
        }

        .delete-btn {
            background: none;
            border: none;
            color: #dc3545;
            cursor: pointer;
            font-size: 0.9rem;
            transition: color 0.3s;
        }

        .delete-btn:hover {
            color: #a71d2a;
        }

        .dropdown-footer {
            padding: 12px;
            border-top: 1px solid #eee;
            text-align: center;
        }

        .mark-all-read {
            background: #4a90e2;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background 0.3s;
        }

        .mark-all-read:hover {
            background: #357abd;
        }

        .empty-state {
            padding: 30px;
            text-align: center;
            color: #999;
        }

        .empty-state i {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        @media (max-width: 768px) {
            .zm-header {
                padding: 1.5rem 5%;
            }

            .zm-navbar {


                gap: 1rem;
            }

            .zm-nav-link {
                font-size: 1.4rem;
            }

            .zm-dropdown-panel {
                right: 5%;
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <header class="zm-header">
        <a href="index.jsp" class="zm-logo">
            <i class="fas fa-shopping-basket"></i> ZestyMart
        </a>

        <nav class="zm-navbar">
            <a href="index.jsp" class="zm-nav-link">Home</a>
            <a href="shop.jsp" class="zm-nav-link">Shop</a>
            <a href="about.jsp" class="zm-nav-link">About</a>
            <a href="contact.jsp" class="zm-nav-link">Contact</a>
        </nav>

        <div class="zm-icons-container">
            <!-- Cart Icon -->
            <button class="zm-icon-btn" id="zm-cart-btn">
                <i class="fas fa-shopping-cart"></i>
                <span class="zm-cart-count" id="cart-count"></span>
            </button>

            <!-- Notification Icon -->
            <button class="zm-icon-btn" id="zm-notification-btn">
                <i class="fas fa-bell"></i>
                <span class="zm-cart-count" id="notification-count"></span>
            </button>

            <!-- Login Icon -->
            <a href="profile.jsp" class="zm-icon-btn"><i class="fas fa-user"></i></a>

            <!-- Cart Dropdown -->
            <div class="zm-dropdown-panel" id="zm-cart-dropdown">
                <div class="zm-dropdown-header">
                    <h3>Your Cart</h3>
                    <button class="zm-close-btn" id="zm-close-cart">×</button>
                </div>
                <p>Cart preview or item list goes here.</p>
                <a href="CartServlet">Go to Cart</a>
            </div>

            <!-- Notification Dropdown -->
            <div class="zm-dropdown-panel" id="zm-notification-dropdown">
                <div class="zm-dropdown-header">
                    <h3>Notifications</h3>
                    <button class="zm-close-btn" id="zm-close-notification">×</button>
                </div>
                <div class="empty-state">
                    <i class="fas fa-bell-slash"></i>
                    <p>No new notifications.</p>
                </div>
            </div>
        </div>
    </header>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const user = '<%= session.getAttribute("user") != null ? "loggedIn" : "" %>';
            if (user) {
                updateNotificationCount(); // Fetch and display notification count on load
                updateCartCount(); // Optionally fetch cart count
            }
        });

        const zmCartBtn = document.getElementById('zm-cart-btn');
        const zmCartDropdown = document.getElementById('zm-cart-dropdown');
        const zmCloseCart = document.getElementById('zm-close-cart');
        const zmNotificationBtn = document.getElementById('zm-notification-btn');
        const zmNotificationDropdown = document.getElementById('zm-notification-dropdown');
        const zmCloseNotification = document.getElementById('zm-close-notification');

        zmCartBtn.addEventListener('click', () => {
            zmCartDropdown.classList.toggle('active');
            zmNotificationDropdown.classList.remove('active');
        });

        zmCloseCart.addEventListener('click', () => {
            zmCartDropdown.classList.remove('active');
        });

        zmNotificationBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            zmNotificationDropdown.classList.toggle('active');
            zmCartDropdown.classList.remove('active');
            if (zmNotificationDropdown.classList.contains('active')) {
                loadNotifications();
            }
        });

        zmCloseNotification.addEventListener('click', () => {
            zmNotificationDropdown.classList.remove('active');
        });

        document.addEventListener('click', (e) => {
            if (!zmCartDropdown.contains(e.target) && !zmCartBtn.contains(e.target)) {
                zmCartDropdown.classList.remove('active');
            }
            if (!zmNotificationDropdown.contains(e.target) && !zmNotificationBtn.contains(e.target)) {
                zmNotificationDropdown.classList.remove('active');
            }
        });

        zmNotificationDropdown.addEventListener('click', (e) => {
            if (e.target.classList.contains('zm-close-btn')) {
                zmNotificationDropdown.classList.remove('active');
                return;
            }

            const item = e.target.closest('.notification-item');
            if (!item || e.target.classList.contains('delete-btn')) return;

            const message = item.querySelector('p');
            const isExpanded = message.classList.contains('expanded');

            document.querySelectorAll('.notification-item p').forEach(p => {
                p.classList.remove('expanded');
            });
            document.querySelectorAll('.notification-item').forEach(i => {
                i.classList.remove('expanded');
            });

            if (!isExpanded) {
                message.classList.add('expanded');
                item.classList.add('expanded');

                if (item.classList.contains('unread')) {
                    const notificationId = item.dataset.id;
                    markAsRead(notificationId, item);
                }
            }
        });

        function updateNotificationCount() {
            fetch('UserServlet?action=count', {
                credentials: 'same-origin'
            })
            .then(response => {
                if (response.status === 401) {
                    window.location.href = 'login.jsp';
                    return Promise.reject('Unauthorized');
                }
                return response.text();
            })
            .then(count => {
                const notificationCountElement = document.getElementById('notification-count');
                const parsedCount = parseInt(count) || 0;
                notificationCountElement.textContent = parsedCount;
                notificationCountElement.style.display = parsedCount > 0 ? 'inline-block' : 'none';
            })
            .catch(error => {
                console.error('Error updating notification count:', error);
                const notificationCountElement = document.getElementById('notification-count');
                notificationCountElement.style.display = 'none'; // Hide on error
            });
        }

        function updateCartCount() {
            // Placeholder: Replace with actual fetch to CartServlet or similar
            fetch('CartServlet?action=count', { credentials: 'same-origin' })
            .then(response => response.text())
            .then(count => {
                const cartCountElement = document.getElementById('cart-count');
                const parsedCount = parseInt(count) || 0;
                cartCountElement.textContent = parsedCount;
                cartCountElement.style.display = parsedCount > 0 ? 'inline-block' : 'none';
            })
            .catch(error => {
                console.error('Error updating cart count:', error);
                const cartCountElement = document.getElementById('cart-count');
                cartCountElement.style.display = 'none';
            });
        }

        function loadNotifications() {
            fetch('UserServlet?action=dropdown', {
                credentials: 'same-origin'
            })
            .then(response => {
                if (response.status === 401) {
                    window.location.href = 'login.jsp';
                    return Promise.reject('Unauthorized');
                }
                return response.text();
            })
            .then(html => {
                if (html) {
                    zmNotificationDropdown.innerHTML = html;
                    updateNotificationCount(); // Refresh count after loading
                }
            })
            .catch(error => console.error('Error loading notifications:', error));
        }

        function markAsRead(notificationId, item) {
            fetch(`UserServlet?action=markAsRead&notificationId=${notificationId}`, {
                method: 'GET',
                credentials: 'same-origin'
            })
            .then(response => response.text())
            .then(success => {
                if (success === 'true') {
                    item.classList.remove('unread');
                    updateNotificationCount();
                }
            })
            .catch(error => console.error('Error marking as read:', error));
        }

        function markAllAsRead() {
            fetch('UserServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markAllAsRead',
                credentials: 'same-origin'
            })
            .then(response => response.text())
            .then(success => {
                if (success === 'true') {
                    document.querySelectorAll('.notification-item.unread').forEach(item => {
                        item.classList.remove('unread');
                    });
                    updateNotificationCount();
                }
            })
            .catch(error => console.error('Error marking all as read:', error));
        }

        function deleteNotification(event, notificationId) {
            event.stopPropagation();
            if (confirm('Are you sure you want to delete this notification?')) {
                fetch('UserServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=delete&id=${notificationId}`,
                    credentials: 'same-origin'
                })
                .then(response => response.text())
                .then(success => {
                    if (success === 'true') {
                        document.querySelector(`.notification-item[data-id="${notificationId}"]`).remove();
                        updateNotificationCount();
                    }
                })
                .catch(error => console.error('Error deleting notification:', error));
            }
        }
    </script>
</body>
</html>