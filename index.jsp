<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lenskart Clone</title>
    <link rel="stylesheet" href="style.css" />
  </head>
  <body data-page="home">
    <!-- Announcement Bar -->
    <div class="announcement-bar">
      Free home eye check-up with every order above Rs. 1499 &nbsp;|&nbsp; Use code LENS10 for 10% off
    </div>
    <!-- Navbar -->
    <nav class="navbar">
      <div class="navbar-inner">
        <a href="index.jsp" class="logo">
          <div class="logo-icon">👁</div>
          <span class="logo-text">FRAME AND TREND</span>
        </a>
        <div class="search-bar">
          <input type="search" placeholder="Search for eyeglasses..." />
          <button class="search-btn">🔍</button>
        </div>
        <ul class="nav-links">
          <li><a href="products.jsp?cat=Eyeglasses">Eyeglasses</a></li>
          <li><a href="products.jsp?cat=Sunglasses">Sunglasses</a></li>
          <li><a href="products.jsp?cat=Contact+Lenses">Contact Lenses</a></li>
        </ul>
        <div class="nav-actions">
          <% if (session.getAttribute("user_id") != null) { %>
            <a href="profile.jsp">👤 <%= session.getAttribute("user_name") %></a>
            <a href="logout.jsp" style="color: grey; font-size: 12px; margin-left: 5px;">Logout</a>
          <% } else { %>
            <a href="login.jsp">👤 Sign In</a>
          <% } %>
          <a href="cart.jsp" style="position:relative">
            🛒 Cart
            <span class="cart-badge" style="display:none">0</span>
          </a>
        </div>
      </div>
    </nav>
    <!-- Hero Section -->
    <section class="hero">
      <div class="hero-bg"></div>
      <div class="hero-content">
        <h1 class="hero-title">See the World Clearly</h1>
        <p class="hero-sub">Premium eyewear starting at Rs. 999. Free home eye check-up with every order.</p>
        <a href="products.jsp?cat=Eyeglasses" class="btn btn-white hero-cta" style="color: #006761; padding: 12px 24px; border-radius: 8px; font-weight: bold; background: white; text-decoration: none; display: inline-block;">Shop Eyeglasses</a>
        <div class="hero-dots">
          <button class="hero-dot active"></button>
          <button class="hero-dot"></button>
          <button class="hero-dot"></button>
        </div>
      </div>
    </section>
    <!-- Featured Products -->
    <section class="section">
      <div class="section-header">
        <div>
          <h2>Featured Products</h2>
          <p>Hand-picked for your style and comfort.</p>
        </div>
        <a href="products.jsp" class="view-all">View All ➞</a>
      </div>
      <div class="product-grid" id="featured-grid">
        <!-- Rendered by script.js -->
      </div>
    </section>
    <!-- Footer -->
    <footer>
      <div class="footer-inner">
        <div class="footer-brand">
          <div class="logo-text">Lenskart</div>
          <p>India's largest eyewear platform.</p>
        </div>
        <div class="footer-col">
          <h4>Shop</h4>
          <ul>
            <li><a href="products.jsp?cat=Eyeglasses">Eyeglasses</a></li>
            <li><a href="products.jsp?cat=Sunglasses">Sunglasses</a></li>
          </ul>
        </div>
        <div class="footer-col"><h4>Help</h4><ul><li><a href="#">Track Order</a></li></ul></div>
        <div class="footer-col">
          <h4>Account</h4>
          <ul>
            <% if (session.getAttribute("user_id") != null) { %>
              <li><a href="profile.jsp">My Profile</a></li>
            <% } else { %>
              <li><a href="login.jsp">Sign In</a></li>
            <% } %>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">&copy; 2024 Lenskart Clone</div>
    </footer>
    <script src="script.js"></script>
    <script>
      // Load cart badge
      document.addEventListener('DOMContentLoaded', updateCartBadge);
    </script>
  </body>
</html>
