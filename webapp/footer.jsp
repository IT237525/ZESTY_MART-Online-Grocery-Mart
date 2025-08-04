<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZestyMart</title>

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- Custom CSS Files -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style1.css">
</head>
<body>
     <section class="footer">

    <div class="box-container">

        <div class="box">
            <h3>quick links</h3>
            <a href="home.jsp"> <i class="fas fa-arrow-right"></i> home</a>
            <a href="shop.jsp"> <i class="fas fa-arrow-right"></i> shop</a>
            <a href="about.jsp"> <i class="fas fa-arrow-right"></i> about</a>
            <a href="review.jsp"> <i class="fas fa-arrow-right"></i> review</a>
            <a href="blog.jsp"> <i class="fas fa-arrow-right"></i> blog</a>
            <a href="contact.jsp"> <i class="fas fa-arrow-right"></i> contact</a>
        </div>

        <div class="box">
            <h3>extra links</h3>
            <a href="#"> <i class="fas fa-arrow-right"></i> my order </a>
            <a href="#"> <i class="fas fa-arrow-right"></i> my favorite </a>
            <a href="#"> <i class="fas fa-arrow-right"></i> my wishlist </a>
            <a href="#"> <i class="fas fa-arrow-right"></i> my account </a>
            <a href="#"> <i class="fas fa-arrow-right"></i> terms or use </a>
        </div>

        <div class="box">
            <a href="https://facebook.com/freewebsitecode/"> <i class="fab fa-facebook-f"></i> facebook </a>
            <a href="https://freewebsitecode.com/"> <i class="fab fa-twitter"></i> twitter </a>
            <a href="https://www.youtube.com/channel/UC9HlQRmKgG3jeVD_fBxj1Pw/videos"> <i class="fab fa-youtube"></i> youtube </a>
            <a href="https://freewebsitecode.com/"> <i class="fab fa-instagram"></i> instagram </a>
            <a href="https://freewebsitecode.com/"> <i class="fab fa-linkedin"></i> linkedin </a>
            <a href="https://freewebsitecode.com/"> <i class="fab fa-pinterest"></i> pinterest </a>
        </div>

       <%@ include file="calendar.jsp" %>

    </div>

</section>

<section class="credit">
    <div class="col-md-6 copyright">
    <p>© 2023 ZestyMart. All rights reserved.</p>
  </div></section>



<script src="js/script.js"></script>
</body>
</html>