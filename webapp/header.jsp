<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ZestyMart</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        .zm-header-container {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: linear-gradient(180deg, #fff, #f9f9f9);
            padding: 1.5rem 9%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            z-index: 1000;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .zm-header-logo {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            text-decoration: none;
            transition: transform 0.3s;
        }

        .zm-header-logo:hover {
            transform: scale(1.05);
        }

        .zm-header-logo i {
            color: #bac34e;
            margin-right: 0.3rem;
        }

        .zm-header-navbar {
            display: flex;
            gap: 2rem;
        }

        .zm-header-nav-link {
            font-size: 1.7rem;
            color: #666;
            text-decoration: none;
            position: relative;
            transition: color 0.3s;
        }

        .zm-header-nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -4px;
            left: 0;
            background: #bac34e;
            transition: width 0.3s;
        }

        .zm-header-nav-link:hover::after {
            width: 100%;
        }

        .zm-header-nav-link:hover {
            color: #bac34e;
        }

        .zm-header-icons {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            position: relative;
        }

        .zm-header-icon-btn {
            font-size: 2rem;
            color: #666;
            cursor: pointer;
            background: none;
            border: none;
            position: relative;
            transition: color 0.3s, transform 0.2s;
        }

        .zm-header-icon-btn:hover {
            color: #bac34e;
            transform: scale(1.1);
        }

        .zm-header-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            background: #fff;
            width: 380px;
            max-width: 90vw;
            padding: 0.5rem;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            border: 2px solid #bac34e;
            display: none;
            z-index: 2000;
            animation: zmHeaderFadeIn 0.4s ease;
            transform-origin: top;
        }

        .zm-header-dropdown.active {
            display: block;
        }

        @keyframes zmHeaderFadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        .zm-header-dropdown-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.8rem 1.2rem;
            border-bottom: 1px solid #eee;
            margin-bottom: 0.5rem;
        }

        .zm-header-close-btn {
            font-size: 1.4rem;
            background: none;
            border: none;
            cursor: pointer;
            color: #999;
            transition: color 0.3s;
        }

        .zm-header-close-btn:hover {
            color: #bac34e;
        }

        @media (max-width: 768px) {
            .zm-header-container {
                padding: 1rem 5%;
            }
            .zm-header-dropdown {
                right: 5%;
                width: 90%;
                top: 80px;
            }
            .zm-header-logo {
                font-size: 2rem;
            }
            .zm-header-nav-link {
                font-size: 1.4rem;
            }
            .zm-header-icon-btn {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>

<header class="zm-header-container">
    <a href="index.jsp" class="zm-header-logo">
        <i class="fas fa-shopping-basket"></i> ZestyMart
    </a>

    <nav class="zm-header-navbar">
        <a href="index.jsp" class="zm-header-nav-link">Home</a>
        <a href="shop.jsp" class="zm-header-nav-link">Shop</a>
        <a href="about.jsp" class="zm-header-nav-link">About</a>
        <a href="contact.jsp" class="zm-header-nav-link">Contact</a>
    </nav>

    <div class="zm-header-icons">
        <!-- Login Icon -->
        <button class="zm-header-icon-btn" id="zm-header-login-btn">
            <i class="fas fa-user"></i>
        </button>

        <!-- Login/Register Dropdown -->
        <div class="zm-header-dropdown" id="zm-header-auth-dropdown">
            
            <% request.setAttribute("isHeaderIncluded", true); %>
            <%@ include file="login.jsp" %>
        </div>
    </div>
</header>

<script>
    // Dropdown toggle functionality
    const loginBtn = document.getElementById('zm-header-login-btn');
    const authDropdown = document.getElementById('zm-header-auth-dropdown');
    const closeAuthBtn = document.getElementById('zm-header-close-auth');

    function closeAllDropdowns() {
        authDropdown.classList.remove('active');
    }

    loginBtn.addEventListener('click', () => {
        closeAllDropdowns();
        authDropdown.classList.toggle('active');
    });

    closeAuthBtn.addEventListener('click', () => {
        authDropdown.classList.remove('active');
    });

    document.addEventListener('click', (e) => {
        if (!loginBtn.contains(e.target) && !authDropdown.contains(e.target)) {
            authDropdown.classList.remove('active');
        }
    });
</script>

</body>
</html>
