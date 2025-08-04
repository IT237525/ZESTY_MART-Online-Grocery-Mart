<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.0/css/line.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;400;500;600&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        :root {
            --primary-color: #FFF;
            --panel-color: #FFF;
            --text-color: #000;
            --black-light-color: #707070;
            --border-color: #e6e5e5;
            --toggle-color: #DDD;
            --title-icon-color: #fff;
        }

        body.dark {
            --primary-color:#3A3B3C;
            --panel-color: #242526;
            --text-color: #CCC;
            --black-light-color: #CCC;
            --border-color: #4D4C4C;
            --toggle-color: #FFF;
            --title-icon-color: #CCC;
        }

        /* Custom Scroll Bar */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        ::-webkit-scrollbar-thumb {
            background: var(--primary-color);
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        body.dark::-webkit-scrollbar-thumb {
            background: #3A3B3C;
        }

        nav {
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            width: 250px;
            padding: 10px 14px;
            background-color: var(--panel-color);
            border-right: 1px solid var(--border-color);
            transition: all 0.5s ease;
        }
        nav.close {
            width: 73px;
        }
        nav .logo-name {
            display: flex;
            align-items: center;
        }
        nav .logo-image {
            display: flex;
            justify-content: center;
            min-width: 45px;
        }
        nav .logo-image img {
            width: 40px;
            object-fit: cover;
            border-radius: 50%;
        }
        nav .logo-name .logo_name {
            font-size: 22px;
            font-weight: 600;
            color: var(--text-color);
            margin-left: 14px;
            transition: all 0.5s ease;
        }
        nav.close .logo_name {
            opacity: 0;
            pointer-events: none;
        }
        nav .menu-items {
            margin-top: 40px;
            height: calc(100% - 90px);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .menu-items li {
            list-style: none;
        }
        .menu-items li a {
            display: flex;
            align-items: center;
            height: 50px;
            text-decoration: none;
            position: relative;
        }
        .nav-links li a:hover:before {
            content: "";
            position: absolute;
            left: -7px;
            height: 5px;
            width: 5px;
            border-radius: 50%;
            background-color: var(--primary-color);
        }
        body.dark .nav-links li a:hover:before {
            background-color: var(--text-color);
        }
        .menu-items li a i {
            font-size: 24px;
            min-width: 45px;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--black-light-color);
        }
        .menu-items li a .link-name {
            font-size: 18px;
            font-weight: 400;
            color: var(--black-light-color);
            transition: all 0.5s ease;
        }
        nav.close li a .link-name {
            opacity: 0;
            pointer-events: none;
        }
        .nav-links li a:hover i,
        .nav-links li a:hover .link-name {
            color: var(--primary-color);
        }
        body.dark .nav-links li a:hover i,
        body.dark .nav-links li a:hover .link-name {
            color: var(--text-color);
        }
        .menu-items .logout-mode {
            padding-top: 10px;
            border-top: 1px solid var(--border-color);
        }
        .menu-items .mode {
            display: flex;
            align-items: center;
            white-space: nowrap;
        }
        .menu-items .mode-toggle {
            position: absolute;
            right: 14px;
            height: 50px;
            min-width: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        .mode-toggle .switch {
            position: relative;
            display: inline-block;
            height: 24px;
            width: 50px;
            border-radius: 25px;
            background-color: var(--toggle-color);
        }
        .switch:before {
            content: "";
            position: absolute;
            left: 5px;
            top: 50%;
            transform: translateY(-50%);
            height: 18px;
            width: 18px;
            background-color: var(--panel-color);
            border-radius: 50%;
            transition: all 0.3s ease;
        }
        body.dark .switch:before {
            left: 27px;
        }

        @media (max-width: 1000px) {
            nav {
                width: 73px;
            }
            nav.close {
                width: 250px;
            }
            nav .logo_name {
                opacity: 0;
                pointer-events: none;
            }
            nav.close .logo_name {
                opacity: 1;
                pointer-events: auto;
            }
            nav li a .link-name {
                opacity: 0;
                pointer-events: none;
            }
            nav.close li a .link-name {
                opacity: 1;
                pointer-events: auto;
            }
        }
        @media (max-width: 400px) {
            nav {
                width: 0;
            }
            nav.close {
                width: 73px;
            }
            nav .logo_name,
            nav li a .link-name {
                opacity: 0;
                pointer-events: none;
            }
            nav.close .logo_name,
            nav.close li a .link-name {
                opacity: 0;
                pointer-events: none;
            }
        }
    </style>
</head>
<body>
    <nav>
        <div class="logo-name">
            <div class="logo-image">
                <img src="images/logo.png" alt="">
            </div>
            <span class="logo_name">Zesty Mart</span>
        </div>
        <div class="menu-items">
            <ul class="nav-links">
                <li><a href="admin.jsp">
                    <i class="uil uil-estate"></i>
                    <span class="link-name">Dashboard</span>
                </a></li>
                <li><a href="user-management">
                    <i class="uil uil-users-alt"></i>
                    <span class="link-name">User</span>
                </a></li>
                <li><a href="admincategory.jsp">
                    <i class="uil uil-tag-alt"></i>
                    <span class="link-name">Category</span>
                </a></li>
                <li><a href="adminproduct.jsp">
                    <i class="uil uil-box"></i>
                    <span class="link-name">Products</span>
                </a></li>
                <li><a href="adminaddcart.jsp">
                    <i class="uil uil-shopping-cart"></i>
                    <span class="link-name">Addcart</span>
                </a></li>
                <li><a href="NotificationServlet">
                    <i class="uil uil-bell"></i>
                    <span class="link-name">Notification</span>
                </a></li>
                <li><a href="admin-contact">
                    <i class="uil uil-envelope"></i>
                    <span class="link-name">Contact</span>
                </a></li>
            </ul>
            <ul class="logout-mode">
                <li><a href="logout">
                    <i class="uil uil-signout"></i>
                    <span class="link-name">Logout</span>
                </a></li>
                <li class="mode">
                    <a href="#">
                        <i class="uil uil-moon"></i>
                        <span class="link-name">Dark Mode</span>
                    </a>
                    <div class="mode-toggle">
                        <span class="switch"></span>
                    </div>
                </li>
            </ul>
        </div>
    </nav>
    <script>
        const body = document.querySelector("body");
        const modeToggle = document.querySelector(".mode-toggle");
        const sidebar = document.querySelector("nav");

        modeToggle.addEventListener("click", () => {
            body.classList.toggle("dark");
            // Save preference to localStorage
            if (body.classList.contains("dark")) {
                localStorage.setItem("darkMode", "enabled");
            } else {
                localStorage.removeItem("darkMode");
            }
        });

        // Check localStorage for dark mode preference
        if (localStorage.getItem("darkMode") === "enabled") {
            body.classList.add("dark");
        }

        // Sidebar toggle (unchanged)
        sidebar.addEventListener("click", (event) => {
            if (event.target.closest(".logo-name") || event.target.closest(".nav-links li a")) {
                sidebar.classList.toggle("close");
            }
        });
    </script>
</body>
</html>