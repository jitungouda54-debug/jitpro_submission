<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Products - Lenskart</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body data-page="products">
  <!-- Announcement Bar -->
  <div class="announcement-bar">
    Free home eye check-up with every order above Rs. 1499 &nbsp;|&nbsp; Use code LENS10 for 10% off
  </div>
  <!-- Navbar -->
  <nav class="navbar">
    <div class="navbar-inner">
      <a href="index.jsp" class="logo">
        <div class="logo-icon">👁</div>
        <span class="logo-text">Lenskart</span>
      </a>
      <div class="search-bar">
        <input type="search" id="nav-search" placeholder="Search for eyeglasses, sunglasses..." />
        <button class="search-btn" onclick="navSearch()">🔍</button>
      </div>
      <ul class="nav-links">
        <li><a href="products.jsp?cat=Eyeglasses">Eyeglasses</a></li>
        <li><a href="products.jsp?cat=Sunglasses">Sunglasses</a></li>
        <li><a href="products.jsp?cat=Contact+Lenses">Contact Lenses</a></li>
      </ul>
      <div class="nav-actions">
        <% if (session.getAttribute("user_id") != null) { %>
          <a href="profile.jsp">👤 <span><%= session.getAttribute("user_name") %></span></a>
          <a href="logout.jsp" style="color: grey; font-size: 12px; margin-left: 5px;">Logout</a>
        <% } else { %>
          <a href="login.jsp">👤 <span>Sign In</span></a>
        <% } %>
        <a href="cart.jsp" style="position:relative">
          🛒 <span>Cart</span>
          <span class="cart-badge" style="display:none">0</span>
        </a>
      </div>
    </div>
  </nav>
  <!-- Page Header -->
  <div class="page-header">
    <div class="breadcrumb">
      <a href="index.jsp">Home</a> › <span id="breadcrumb-cat">Products</span>
    </div>
  </div>
  <!-- Products Layout -->
  <div class="products-layout">
    <!-- Sidebar -->
    <aside class="sidebar">
      <div class="sidebar-section">
        <h3>Category</h3>
        <button class="filter-btn active" data-cat="">All Categories</button>
        <button class="filter-btn" data-cat="Eyeglasses">Eyeglasses</button>
        <button class="filter-btn" data-cat="Sunglasses">Sunglasses</button>
        <button class="filter-btn" data-cat="Contact Lenses">Contact Lenses</button>
        <button class="filter-btn" data-cat="Computer Glasses">Computer Glasses</button>
        <button class="filter-btn" data-cat="Kids Glasses">Kids Glasses</button>
      </div>
      <div class="sidebar-section">
        <h3>Price Range</h3>
        <div class="price-input-row">
          <input type="number" id="min-price" placeholder="Min" />
          <input type="number" id="max-price" placeholder="Max" />
        </div>
        <button id="apply-price" class="btn btn-outline" style="width:100%;margin-top:10px;padding:8px;font-size:13px;">Apply</button>
        <div style="margin-top:12px;">
          <button class="filter-btn" onclick="setPriceRange(0,1000)">Under Rs. 1,000</button>
          <button class="filter-btn" onclick="setPriceRange(1000,2000)">Rs. 1,000 – 2,000</button>
          <button class="filter-btn" onclick="setPriceRange(2000,99999)">Above Rs. 2,000</button>
        </div>
      </div>
    </aside>
    <!-- Products Main -->
    <main class="products-main">
      <div class="products-topbar">
        <h1 id="products-title">All Eyewear</h1>
        <span class="product-count" id="product-count"></span>
        <input
          type="search"
          id="products-search"
          placeholder="Search products..."
          style="padding:9px 14px;border-radius:8px;border:1.5px solid #e0e0e0;font-size:13px;outline:none;width:200px;"
        />
        <select class="sort-select" id="sort-select">
          <option value="default">Sort by</option>
          <option value="price-asc">Price: Low to High</option>
          <option value="price-desc">Price: High to Low</option>
          <option value="rating">Best Rated</option>
        </select>
      </div>
      <div class="product-grid" id="products-grid">
        <!-- Rendered by script.js -->
      </div>
    </main>
  </div>
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
          <li><a href="products.jsp?cat=Contact+Lenses">Contact Lenses</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Help</h4>
        <ul><li><a href="#">Track Order</a></li></ul>
      </div>
      <div class="footer-col">
        <h4>Account</h4>
        <ul>
          <li><a href="login.jsp">Sign In</a></li>
          <li><a href="profile.jsp">Profile</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">&copy; 2024 Lenskart Clone</div>
  </footer>
  <script src="script.js"></script>
  <script>
    function navSearch() {
      const q = document.getElementById('nav-search').value.trim();
      if (q) { document.getElementById('products-search').value = q; }
    }
    function setPriceRange(min, max) {
      document.getElementById('min-price').value = min || '';
      document.getElementById('max-price').value = max === 99999 ? '' : max;
      document.getElementById('apply-price').click();
    }
    const params = new URLSearchParams(window.location.search);
    const cat = params.get('cat');
    if (cat) document.getElementById('breadcrumb-cat').textContent = cat;
  </script>
</body>
</html>