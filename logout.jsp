<%--
  ==========================================
  LENSKART CLONE - LOGOUT.JSP
  Destroys the user session and redirects
  to the login page with a success message.
  ==========================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    /* ---- Invalidate the current session ---- */
    HttpSession sess = request.getSession(false);
    if (sess != null) {
        sess.invalidate();
    }
    /* ---- Clear the session cookie ---- */
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("JSESSIONID".equals(c.getName())) {
                c.setValue("");
                c.setMaxAge(0);
                c.setPath("/");
                response.addCookie(c);
            }
        }
    }
    /* ---- Redirect to login page with logout confirmation ---- */
    response.sendRedirect("login.jsp?logout=1");
%>