<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Security Check: Redirect if not logged in
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp?from=checkout");
        return;
    }

    double finalTotal = 0.0;
    try {
        String totalParam = request.getParameter("total");
        if (totalParam != null && !totalParam.trim().isEmpty()) {
            finalTotal = Double.parseDouble(totalParam.trim());
        }
    } catch (Exception ignore) {
        finalTotal = 0.0;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout - Lenskart</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .checkout-container { max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; border-radius: 12px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group textarea, .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 6px; }
    </style>
</head>
<body>
    <div class="checkout-container">
        <h1>Finalize Order</h1>
        <p>User: <strong><%= session.getAttribute("user_name") %></strong></p>
        
        <form action="order.jsp" method="POST">
            <div class="form-group">
                <label>Shipping Address</label>
                <textarea name="address" rows="4" placeholder="Enter your full address..." required></textarea>
            </div>
            
            <div class="form-group">
                <label>Payment Method</label>
                <select name="payment_method" style="width: 100%; padding: 10px; border-radius: 6px;">
                    <option value="COD">Cash on Delivery</option>
                    <option value="UPI">UPI / QR Code</option>
                    <option value="Card">Credit/Debit Card</option>
                </select>
            </div>

            <input type="hidden" name="total_amount" id="final-total-input" value="<%= String.format(java.util.Locale.US, "%.2f", finalTotal) %>">

            <div style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 10px;">
                <h3>Total Payable: Rs. <span id="display-total"><%= String.format(java.util.Locale.US, "%.2f", finalTotal) %></span></h3>
            </div>

            <button type="submit" class="submit-btn" style="background:#006761; color:white; width:100%; padding:15px; border:none; border-radius:8px; cursor:pointer; font-weight:bold; margin-top:20px;">
                PLACE ORDER
            </button>
        </form>
    </div>
</body>
</html>