<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Contact" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us</title>

    <!-- font awesome cdn link  -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- custom css file link  -->
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Chat UI Styling */
        .chat-container {
            width: 100%;
            background-color: #f5f5f5;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .chat-header {
            background-color: #128C7E;
            color: white;
            padding: 15px;
            display: flex;
            align-items: center;
        }
        
        .chat-header .profile-pic {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-right: 15px;
        }
        
        .chat-body {
            background-color: #E5DDD5;
            background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23d4d4d4' fill-opacity='0.4'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            padding: 15px;
            min-height: 200px;
            max-height: 350px;
            overflow-y: auto;
        }
        
        .message {
            max-width: 75%;
            padding: 10px 15px;
            margin-bottom: 15px;
            border-radius: 10px;
            position: relative;
            word-wrap: break-word;
        }
        
        .message-time {
            font-size: 11px;
            color: #777;
            text-align: right;
            margin-top: 5px;
        }
        
        .sent {
            background-color: #DCF8C6;
            margin-left: auto;
            margin-right: 10px;
            border-top-right-radius: 0;
        }
        
        .received {
            background-color: white;
            margin-left: 10px;
            margin-right: auto;
            border-top-left-radius: 0;
        }
        
        .chat-input {
            display: flex;
            padding: 10px;
            background-color: #F0F0F0;
            align-items: center;
        }
        
        .chat-input textarea {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 20px;
            resize: none;
            outline: none;
            height: 40px;
        }
        
        .chat-input button {
            background-color: #128C7E;
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            margin-left: 10px;
            cursor: pointer;
            outline: none;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .success-message {
            background-color: #4CAF50;
            color: white;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        
        .error-message {
            background-color: #f44336;
            color: white;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .row {
                flex-direction: column;
            }
            
            .map {
                height: 300px;
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>
    
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    
    // Get attributes from request
    Contact submittedContact = (Contact) request.getAttribute("submittedContact");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    List<Contact> userContacts = (List<Contact>) request.getAttribute("userContacts");
%>

<%
    // Include header1.jsp if session exists (user is logged in), otherwise include header.jsp
    if (user != null) {
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
    <h1>contact us</h1>
    <p> <a href="index.jsp">home >></a> contact </p>
</div>


<section class="contact">

    <div class="icons-container">

        <div class="icons">
            <i class="fas fa-phone"></i>
            <h3>our number</h3>
            <p>0771234567</p>
            <p>021-22-2512</p>
        </div>

        <div class="icons">
            <i class="fas fa-envelope"></i>
            <h3>our email</h3>
            <p>zestymart@gmail.com</p>
           
        </div>

        <div class="icons">
            <i class="fas fa-map-marker-alt"></i>
            <h3>our address</h3>
            <p>Jaffna, Sri Lanka - 40000</p>
        </div>

    </div>


    <% if (errorMessage != null) { %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
        </div>
    <% } %>

    <% if (successMessage != null) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i> <%= successMessage %>
        </div>
    <% } %>

    <div class="row">
        <% if (submittedContact != null) { %>
            <!-- Display chat UI when form is submitted -->
            <div class="chat-container">
                <div class="chat-header">
                    <div class="profile-pic">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <h3>Customer Support</h3>
                        <small>Online</small>
                    </div>
                </div>
                <div class="chat-body">
                    <div class="message sent">
                        <p><strong>Subject:</strong> <%= submittedContact.getSubject() %></p>
                        <p><%= submittedContact.getMessage() %></p>
                        <div class="message-time">
                            <span><%= submittedContact.getCreatedAt() %></span>
                            <i class="fas fa-check-double" style="color: #4FC3F7;"></i>
                        </div>
                    </div>
                    
                    <% if (submittedContact.getReply() != null && !submittedContact.getReply().isEmpty()) { %>
                        <div class="message received">
                            <p><%= submittedContact.getReply() %></p>
                            <div class="message-time">
                                <span><%= submittedContact.getCreatedAt() %></span>
                            </div>
                        </div>
                    <% } %>
                </div>
                <div class="chat-input">
                    <textarea placeholder="Type a message..." disabled></textarea>
                    <button disabled><i class="fas fa-paper-plane"></i></button>
                </div>
            </div>
        <% } else { %>
            <!-- Display contact form -->
            <form action="ContactServlet" method="post">
                <h3>get in touch</h3>
                <input type="hidden" name="action" value="submit">
                
                <div class="inputBox">
                    <input type="text" name="name" placeholder="enter your name" class="box" required
                           value="<%= user != null ? user.getFirstName() + " " + user.getLastName() : "" %>">
                </div>
                
                <div class="inputBox">
                    <input type="text" name="phone" placeholder="enter your number" class="box" required
                           value="<%= user != null ? user.getPhone() : "" %>">
                    <input type="text" name="subject" placeholder="enter your subject" class="box" required>
                </div>
                
                <textarea name="message" placeholder="your message" cols="30" rows="10" required></textarea>
                
                <% if (user != null) { %>
                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                <% } %>
                
                <input type="submit" value="send message" class="btn">
            </form>
        <% } %>

		<iframe class="map" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3955.8673654649145!2d80.01760507497398!3d9.661121990450337!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3afe548aaaf91713%3A0x503f57c9cf249d6!2sJaffna%20Hindu%20College!5e0!3m2!1sen!2slk!4v1714982146886!5m2!1sen!2slk" allowfullscreen="" loading="lazy"></iframe>
  </div>
    
    <!-- Display previous messages if available -->
    <% if (userContacts != null && !userContacts.isEmpty()) { %>
        <h2 style="margin-top: 40px; text-align: center;">Your Previous Messages</h2>
        
        <% for (Contact contact : userContacts) { %>
            <div class="chat-container">
                <div class="chat-header">
                    <div class="profile-pic">
                        <i class="fas fa-user"></i>
                    </div>
                    <div>
                        <h3>Customer Support</h3>
                        <small>Subject: <%= contact.getSubject() %></small>
                    </div>
                </div>
                <div class="chat-body">
                    <div class="message sent">
                        <p><%= contact.getMessage() %></p>
                        <div class="message-time">
                            <span><%= contact.getCreatedAt() %></span>
                            <i class="fas fa-check-double" style="color: #4FC3F7;"></i>
                        </div>
                    </div>
                    
                    <% if (contact.getReply() != null && !contact.getReply().isEmpty()) { %>
                        <div class="message received">
                            <p><%= contact.getReply() %></p>
                            <div class="message-time">
                                <span><%= contact.getCreatedAt() %></span>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="message received">
                            <p><i>Waiting for response...</i></p>
                            <div class="message-time">
                                <span><i class="fas fa-clock"></i></span>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    <% } %>

</section>

<%@ include file="footer.jsp" %>

<script src="js/script.js"></script>

</body>
</html>