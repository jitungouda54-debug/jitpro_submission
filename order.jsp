<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jspf" %>
<%
    if (!request.getMethod().equalsIgnoreCase("POST")) {
        response.sendRedirect("cart.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("user_id");
    String address = request.getParameter("address");
    String payment = request.getParameter("payment_method");
    String totalStr = request.getParameter("total_amount");

    if (userId == null) {
        response.sendRedirect("login.jsp?from=checkout");
        return;
    }

    if (address == null || address.trim().isEmpty() || totalStr == null || totalStr.trim().isEmpty()) {
        response.sendRedirect("checkout.jsp?total=0");
        return;
    }

    address = address.trim();
    double total;
    try {
        total = Double.parseDouble(totalStr.trim());
        if (total <= 0) {
            response.sendRedirect("cart.jsp");
            return;
        }
    } catch (Exception parseEx) {
        response.sendRedirect("cart.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet generatedKeys = null;
    int createdOrderId = -1;
    try {
        conn = getDbConnection();
        String sql = "INSERT INTO orders (user_id, total_amount, shipping_address, payment_method) VALUES (?, ?, ?, ?)";
        ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, userId);
        ps.setDouble(2, total);
        ps.setString(3, address);
        ps.setString(4, payment != null ? payment : "COD");

        int result = ps.executeUpdate();
        if (result > 0) {
            generatedKeys = ps.getGeneratedKeys();
            if (generatedKeys.next()) {
                createdOrderId = generatedKeys.getInt(1);
            }
%>
                    <!DOCTYPE html>
                    <html>
                    <head><link rel="stylesheet" href="style.css"></head>
                    <body style="text-align:center; padding:50px;">
                        <div style="font-size: 50px;">OK</div>
                        <h1 style="color:#006761;">Order Placed Successfully!</h1>
                        <p>Thank you, <%= session.getAttribute("user_name") %>. Your order is being processed.</p>
                        <p>Order ID: <strong>#<%= createdOrderId > 0 ? createdOrderId : "N/A" %></strong></p>
                        <p>Delivery Address: <%= address %></p>
                        <a href="profile.jsp?ordered=1" class="btn btn-primary" style="text-decoration:none; background:#006761; color:white; padding:10px 20px; border-radius:5px;">View Order History</a>
                        <script>
                            localStorage.removeItem('lk_cart');
                        </script>
                    </body>
                    </html>
<%
            return;
        }
        response.sendRedirect("cart.jsp");
        return;
    } catch (Exception e) {
        out.println("Error placing order: " + e.getMessage());
    } finally {
        if (generatedKeys != null) try { generatedKeys.close(); } catch (SQLException ex) {}
        if (ps != null) try { ps.close(); } catch (SQLException ex) {}
        if (conn != null) try { conn.close(); } catch (SQLException ex) {}
    }
%>