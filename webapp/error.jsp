<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    
    <!-- font awesome cdn link  -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- custom css file link  -->
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        .error-container {
            padding: 50px 20px;
            text-align: center;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .error-icon {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        
        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        
        .back-buttons {
            margin-top: 30px;
        }
        
        .back-buttons .btn {
            margin: 0 10px;
        }
    </style>
</head>
<body>

<%
    // Include header1.jsp if session exists (user is logged in), otherwise include header.jsp
    if (session != null && session.getAttribute("user") != null) {
%>
        <%@ include file="header1.jsp" %>
<%
    } else {
%>
        <%@ include file="header.jsp" %>
<%
    }
%>

<div class="heading">
    <h1>Error</h1>
    <p><a href="index.jsp">home >></a> error</p>
</div>

<section class="error-container">
    <div class="error-icon">
        <i class="fas fa-exclamation-triangle"></i>
    </div>
    
    <h2>Oops! Something went wrong</h2>
    
    <div class="error-message">
        <p>${requestScope.errorMessage != null ? requestScope.errorMessage : "An unexpected error occurred. Please try again later."}</p>
    </div>
    
    <div class="back-buttons">
        <a href="javascript:history.back()" class="btn"><i class="fas fa-arrow-left"></i> Go Back</a>
        <a href="index.jsp" class="btn"><i class="fas fa-home"></i> Go Home</a>
        <a href="ContactServlet" class="btn"><i class="fas fa-envelope"></i> Contact Us</a>
    </div>
</section>

<%@ include file="footer.jsp" %>

<script src="js/script.js"></script>

</body>
</html>