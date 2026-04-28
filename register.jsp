<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ include file="db.jspf" %>
<%
    String method = request.getMethod();
    String errorMsg = request.getParameter("error");
    if ("POST".equalsIgnoreCase(method)) {
        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (name != null && !name.trim().isEmpty() &&
            email != null && !email.trim().isEmpty() &&
            password != null && !password.trim().isEmpty()) {
            
            name     = name.trim();
            email    = email.trim().toLowerCase();
            password = password.trim();

            // --- PASSWORD COMPLEXITY CHECK (REGEX) ---
            // (?=.*[a-z]) : at least one lowercase
            // (?=.*[A-Z]) : at least one uppercase
            // (?=.*[!@#$%^&*(),.?":{}|<>]) : at least one special char
            // .{8,} : MINIMUM 8 CHARACTERS
            String pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$";
            if (!password.matches(pattern)) {
                response.sendRedirect("register.jsp?error=weak");
                return;
            }

            String hashedPassword = null;
            
            try {
                MessageDigest md = MessageDigest.getInstance("MD5");
                byte[] hashBytes = md.digest(password.getBytes("UTF-8"));
                StringBuilder sb = new StringBuilder();
                for (byte b : hashBytes) sb.append(String.format("%02x", b));
                hashedPassword = sb.toString();
            } catch (Exception ex) {
                response.sendRedirect("register.jsp?error=hash");
                return;
            }

            Connection conn = null;
            PreparedStatement checkPs = null;
            PreparedStatement insertPs = null;
            ResultSet rs = null;

            try {
                conn = getDbConnection();
                
                checkPs = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
                checkPs.setString(1, email);
                rs = checkPs.executeQuery();
                
                if (rs.next()) {
                    response.sendRedirect("register.jsp?error=exists");
                    return;
                }

                insertPs = conn.prepareStatement(
                    "INSERT INTO users (name, email, password_hash, created_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)"
                );
                insertPs.setString(1, name);
                insertPs.setString(2, email);
                insertPs.setString(3, hashedPassword);
                insertPs.executeUpdate();

                response.sendRedirect("login.jsp?registered=1");
                return;
            } catch (Exception e) {
                out.println("<h3>Database error: " + e.getMessage() + "</h3>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (checkPs != null) try { checkPs.close(); } catch (SQLException e) {}
                if (insertPs != null) try { insertPs.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        } else {
            response.sendRedirect("register.jsp?error=empty");
            return;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Create Account - Lenskart</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <div class="login-page">
    <div class="login-card">
      <div class="login-logo">
        <div class="login-logo-icon">👁</div>
        <h1>Lenskart</h1>
        <p>Create your account</p>
      </div>

      <% if ("exists".equals(errorMsg)) { %>
        <div class="error-box show">Email already registered. Please sign in.</div>
      <% } else if ("empty".equals(errorMsg)) { %>
        <div class="error-box show">Please fill all fields.</div>
      <% } else if ("hash".equals(errorMsg)) { %>
        <div class="error-box show">Internal error. Try again.</div>
      <% } else if ("weak".equals(errorMsg)) { %>
        <div class="error-box show">Password must be at least 8 characters with 1 Uppercase, 1 Lowercase, and 1 Special Character.</div>
      <% } %>

      <form id="register-form" action="register.jsp" method="POST">
        <div class="form-group">
          <label for="name">Full name</label>
          <input type="text" id="name" name="name" placeholder="Rahul Sharma" required />
        </div>
        <div class="form-group">
          <label for="email">Email address</label>
          <input type="email" id="email" name="email" placeholder="you@example.com" required />
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <div class="pw-wrap">
            <%-- Updated minlength to 8 and pattern to match --%>
            <input 
              type="password" 
              id="password" 
              name="password" 
              placeholder="Min. 8 characters" 
              required 
              minlength="8"
              pattern="(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*(),.?&quot;:{}|<>]).{8,}"
              title="Must be at least 8 characters and contain at least one uppercase letter, one lowercase letter, and one special character."
            />
            <button type="button" class="pw-toggle" onclick="togglePw()">👁</button>
          </div>
        </div>
        <button type="submit" class="submit-btn" id="submit-btn">Create Account</button>
      </form>
      <div class="login-footer">
        Already have an account? <a href="login.jsp">Sign in</a>
      </div>
    </div>
  </div>
  <script>
    function togglePw() {
      const input = document.getElementById('password');
      const btn = document.querySelector('.pw-toggle');
      input.type = input.type === 'password' ? 'text' : 'password';
      btn.textContent = input.type === 'password' ? '👁' : '🙈';
    }
  </script>
</body>
</html>