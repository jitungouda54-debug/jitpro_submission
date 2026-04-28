<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ include file="db.jspf" %>
<%
    String method = request.getMethod();
    String errorMsg = request.getParameter("error");
    String registeredMsg = request.getParameter("registered");
    if ("POST".equalsIgnoreCase(method)) {
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String fromParam = request.getParameter("from");
        if (email != null && !email.trim().isEmpty() && password != null && !password.trim().isEmpty()) {
            email    = email.trim().toLowerCase();
            password = password.trim();
            String hashedPassword = null;
            try {
                MessageDigest md = MessageDigest.getInstance("MD5");
                byte[] hashBytes = md.digest(password.getBytes("UTF-8"));
                StringBuilder sb = new StringBuilder();
                for (byte b : hashBytes) sb.append(String.format("%02x", b));
                hashedPassword = sb.toString();
            } catch (Exception hashEx) {
                response.sendRedirect("login.jsp?error=1");
                return;
            }
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                conn = getDbConnection();
                String sql = "SELECT id, name, email FROM users WHERE email = ? AND password_hash = ? LIMIT 1";
                ps = conn.prepareStatement(sql);
                ps.setString(1, email);
                ps.setString(2, hashedPassword);
                rs = ps.executeQuery();
                if (rs.next()) {
                    HttpSession sess = request.getSession(true);
                    sess.setAttribute("user_id",    rs.getInt("id"));
                    sess.setAttribute("user_name",  rs.getString("name"));
                    sess.setAttribute("user_email", rs.getString("email"));
                    sess.setMaxInactiveInterval(86400 * 7);
                    if (fromParam != null && !fromParam.isEmpty()) {
                        response.sendRedirect(fromParam + ".jsp");
                    } else {
                        response.sendRedirect("index.jsp");
                    }
                    return;
                } else {
                    response.sendRedirect("login.jsp?error=1");
                    return;
                }
            } catch (Exception e) {
                out.println("<h3>Database error: " + e.getMessage() + "</h3>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (ps != null) try { ps.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign In - Lenskart</title>
    <link rel="stylesheet" href="style.css" />
  </head>
  <body>
    <div class="login-page">
      <div class="login-card">
        <div class="login-logo">
          <div class="login-logo-icon">👁</div>
          <h1>Lenskart</h1>
          <p>Sign in to your account</p>
        </div>
        <% if ("1".equals(errorMsg)) { %>
          <div class="error-box show" id="error-msg">Invalid email or password. Please try again.</div>
        <% } else { %>
          <div class="error-box" id="error-msg"></div>
        <% } %>
        <% if ("1".equals(registeredMsg)) { %>
          <div class="success-box show" id="success-msg">Account created! Please sign in.</div>
        <% } else if ("1".equals(request.getParameter("logout"))) { %>
           <div class="success-box show" id="success-msg">You have been logged out successfully.</div>
        <% } else { %>
          <div class="success-box" id="success-msg"></div>
        <% } %>
        <form id="login-form" action="login.jsp" method="POST">
          <input type="hidden" id="redirect-input" name="from" value="<%= request.getParameter("from") != null ? request.getParameter("from") : "" %>">
          <div class="form-group">
            <label for="email">Email address</label>
            <input type="email" id="email" name="email" placeholder="you@example.com" required />
          </div>
          <div class="form-group">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
              <label for="password" style="margin: 0">Password</label>
            </div>
            <div class="pw-wrap">
              <input type="password" id="password" name="password" placeholder="••••••••" required />
              <button type="button" class="pw-toggle" onclick="togglePw()">👁</button>
            </div>
          </div>
          <button type="submit" class="submit-btn" id="submit-btn">Sign In</button>
        </form>
        <div class="login-footer">
          Don't have an account? <a href="register.jsp">Create one</a>
        </div>
      </div>
    </div>
    <script>
      function togglePw() {
        const input = document.getElementById("password");
        const btn = document.querySelector(".pw-toggle");
        if (input.type === "password") {
          input.type = "text";
          btn.textContent = "🙈";
        } else {
          input.type = "password";
          btn.textContent = "👁";
        }
      }
    </script>
  </body>
</html>