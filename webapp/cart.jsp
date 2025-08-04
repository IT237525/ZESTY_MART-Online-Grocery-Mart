<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zesty Mart - Cart</title>
    <link href="https://fonts.googleapis.com/css2?family=Rubik&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Rubik', sans-serif;
        }
        body {
            margin: 0;
            padding: 0;
            background: #f7f9fc;
        }
        h2 {
            text-align: center;
            margin-top: 30px;
            font-size: 32px;
            color: #333;
        }
        .cart-container {
            padding: 30px 60px;
            max-width: 1200px;
            margin: auto;
        }
        .cart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .cart-item {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            padding: 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        .cart-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .cart-item h3 {
            font-size: 16px;
            color: #333;
            margin: 10px 0;
        }
        .cart-item p {
            font-size: 14px;
            color: #666;
            margin: 5px 0;
        }
        .quantity-controls {
            display: flex;
            align-items: center;
            margin: 10px 0;
        }
        .quantity-btn {
            background: #007bff;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            margin: 0 5px;
        }
        .quantity-btn:hover {
            background: #0056b3;
        }
        .quantity-display {
            width: 40px;
            text-align: center;
            border: none;
            font-size: 14px;
        }
        .action-btn {
            background: #dc3545;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            transition: background 0.3s;
            cursor: pointer;
        }
        .action-btn:hover {
            background: #c82333;
        }
        .error, .success {
            text-align: center;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
        }
        .success {
            background: #d4edda;
            color: #155724;
        }
        .back-btn {
            display: inline-block;
            margin: 20px 60px;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }
        .back-btn:hover {
            background: #0056b3;
        }
        .empty-cart {
            text-align: center;
            font-size: 18px;
            color: #666;
            margin: 50px 0;
        }
        .checkout-btn {
            display: block;
            width: 200px;
            margin: 20px auto;
            padding: 12px;
            background: #28a745;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            transition: background 0.3s;
        }
        .checkout-btn:hover {
            background: #218838;
        }
    </style>
</head>
<body>
    <a href="productinfo.jsp" class="back-btn">Back to Products</a>
    <h2>Your Cart</h2>
    <div class="cart-container">
        <!-- Error and Success messages -->
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>

        <!-- Check if cartItems is empty or not -->
        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-cart">Your cart is empty.</div>
            </c:when>
            <c:otherwise>
                <div class="cart-grid">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item">
                            <img src="image/<c:out value="${item.productImage}"/>" alt="<c:out value="${item.productName}"/>">
                            <h3><c:out value="${item.productName}"/></h3>
                            <p>Price: Rs. <c:out value="${item.unitPrice}"/></p>
                            <div class="quantity-controls">
                                <form action="CartServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="productId" value="${item.productId}">
                                    <button type="submit" name="action" value="decrease" class="quantity-btn">-</button>
                                    <input type="text" class="quantity-display" value="${item.quantity}" readonly>
                                    <button type="submit" name="action" value="increase" class="quantity-btn">+</button>
                                </form>
                            </div>
                            <p>Total: Rs. <c:out value="${item.total}"/></p>
                            <form action="CartServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <button type="submit" class="action-btn">Remove</button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
                <form action="CheckoutServlet" method="get">
                    <button type="submit" class="checkout-btn">Proceed to Checkout</button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
