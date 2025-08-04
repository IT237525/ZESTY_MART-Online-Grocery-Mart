<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zesty Mart - Checkout</title>
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
        .checkout-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .cart-summary {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            padding: 20px;
            margin-bottom: 20px;
        }
        .cart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .cart-item {
            background: #f9f9f9;
            border-radius: 8px;
            padding: 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        .cart-item img {
            width: 80px;
            height: 80px;
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
        .total {
            text-align: right;
            font-size: 18px;
            color: #333;
            margin-top: 20px;
        }
        .checkout-form {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            padding: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #444;
        }
        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .submit-btn {
            display: block;
            width: 100%;
            padding: 12px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .submit-btn:hover {
            background: #218838;
        }
        .error {
            text-align: center;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            background: #f8d7da;
            color: #721c24;
        }
        .no-items {
            text-align: center;
            font-size: 18px;
            color: #666;
            margin: 20px 0;
        }
        .back-btn {
            display: inline-block;
            margin: 20px 60px; /* Adjusted margin for consistency */
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }
        .back-btn:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <a href="CartServlet" class="back-btn">Back to Cart</a>
    <div class="checkout-container">
        <h2>Checkout</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <div class="cart-summary">
            <h3>Order Summary</h3>
            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="no-items">No items to display.</div>
                </c:when>
                <c:otherwise>
                    <div class="cart-grid">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item">
                                <img src="image/<c:out value="${item.productImage}"/>" alt="<c:out value="${item.productName}"/>">
                                <h3><c:out value="${item.productName}"/></h3>
                                <p>Price: Rs. <c:out value="${item.unitPrice}"/></p>
                                <p>Quantity: <c:out value="${item.quantity}"/></p>
                                <p>Total: Rs. <c:out value="${item.total}"/></p>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="total">
                        <p>Grand Total: Rs. <c:out value="${grandTotal}"/></p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="checkout-form">
            <form action="CheckoutServlet" method="post">
                <div class="form-group">
                    <label for="address">Shipping Address</label>
                    <textarea id="address" name="address" required></textarea>
                </div>
                <div class="form-group">
                    <label for="paymentMethod">Payment Method</label>
                    <select id="paymentMethod" name="paymentMethod" required>
                        <option value="">Select Payment Method</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="PayPal">PayPal</option>
                        <option value="Cash on Delivery">Cash on Delivery</option>
                    </select>
                </div>
                <button type="submit" class="submit-btn">Place Order</button>
            </form>
        </div>
    </div>
</body>
</html>