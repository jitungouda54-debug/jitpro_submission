// ==========================================
//  LENSKART CLONE - MAIN JAVASCRIPT
// ==========================================
function getCart() {
  return JSON.parse(localStorage.getItem('lk_cart') || '[]');
}
function saveCart(cart) {
  localStorage.setItem('lk_cart', JSON.stringify(cart));
  updateCartBadge();
}
function updateCartBadge() {
  const cart = getCart();
  const total = cart.reduce((s, i) => s + i.qty, 0);
  document.querySelectorAll('.cart-badge').forEach(el => {
    el.textContent = total > 9 ? '9+' : total;
    el.style.display = total > 0 ? 'flex' : 'none';
  });
}
function addToCart(product) {
  const cart = getCart();
  const existing = cart.find(i => i.id === product.id);
  if (existing) {
    existing.qty += 1;
  } else {
    cart.push({ ...product, qty: 1 });
  }
  saveCart(cart);
  showToast('Added to cart!', 'success');
}
function removeFromCart(productId) {
  const cart = getCart().filter(i => i.id !== productId);
  saveCart(cart);
}
function updateQty(productId, delta) {
  const cart = getCart();
  const item = cart.find(i => i.id === productId);
  if (!item) return;
  item.qty += delta;
  if (item.qty <= 0) {
    removeFromCart(productId);
    return;
  }
  saveCart(cart);
  renderCartPage();
}
function showToast(message, type) {
  let toast = document.getElementById('toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'toast';
    toast.className = 'toast';
    document.body.appendChild(toast);
  }
  toast.textContent = message;
  toast.className = 'toast ' + (type || '');
  setTimeout(() => toast.classList.add('show'), 10);
  setTimeout(() => toast.classList.remove('show'), 2200);
}
const PRODUCTS = [
  { id: 1, name: 'Vincent Chase Full Frame', brand: 'Vincent Chase', category: 'Eyeglasses', price: 1499, originalPrice: 2999, rating: 4.3, reviews: 234, featured: true, inStock: true, frameType: 'Full Frame', color: 'Matte Black', img: 'https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=600&q=80' },
  { id: 2, name: 'Lenskart Air Classic', brand: 'Lenskart Air', category: 'Eyeglasses', price: 999, originalPrice: 1499, rating: 4.5, reviews: 512, featured: true, inStock: true, frameType: 'Rimless', color: 'Gold', img: 'https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=600&q=80' },
  { id: 3, name: 'John Jacobs Retro Round', brand: 'John Jacobs', category: 'Eyeglasses', price: 2499, originalPrice: 3499, rating: 4.2, reviews: 89, featured: false, inStock: true, frameType: 'Full Frame', color: 'Tortoise', img: 'https://images.unsplash.com/photo-1582142306909-195724d33ffc?w=600&q=80' },
  { id: 4, name: 'Polaroid Wayfarer', brand: 'Polaroid', category: 'Sunglasses', price: 1799, originalPrice: 2999, rating: 4.6, reviews: 678, featured: true, inStock: true, frameType: 'Full Frame', color: 'Black', img: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600&q=80' },
  { id: 5, name: 'Ray-Ban Aviator Classic', brand: 'Ray-Ban', category: 'Sunglasses', price: 5999, originalPrice: 7499, rating: 4.8, reviews: 1203, featured: true, inStock: true, frameType: 'Half Frame', color: 'Gold/Green', img: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600&q=80' },
  { id: 7, name: 'Acuvue Oasys Monthly', brand: 'Acuvue', category: 'Contact Lenses', price: 799, originalPrice: 999, rating: 4.7, reviews: 2341, featured: true, inStock: true, frameType: null, color: 'Clear', img: 'https://images.unsplash.com/photo-1587145820266-a5951ee6f620?w=600&q=80' },
  { id: 9, name: 'Lenskart BLU Blue Light', brand: 'Lenskart BLU', category: 'Computer Glasses', price: 1299, originalPrice: 1799, rating: 4.4, reviews: 456, featured: true, inStock: true, frameType: 'Full Frame', color: 'Transparent', img: 'https://images.unsplash.com/photo-1508296695146-257a814070b4?w=600&q=80' }
];
function starsHTML(rating) {
  let html = '';
  for (let i = 1; i <= 5; i++) {
    html += i <= Math.round(rating) ? '★' : '☆';
  }
  return html;
}
function discountPct(price, originalPrice) {
  if (!originalPrice) return null;
  return Math.round(((originalPrice - price) / originalPrice) * 100);
}
function productCardHTML(p, index) {
  const disc = discountPct(p.price, p.originalPrice);
  return `
    <div class="product-card" style="animation-delay:${index * 60}ms">
      <div class="product-img" onclick="window.location='product-buy.jsp?id=${p.id}'">
        <img src="${p.img}" alt="${p.name}" loading="lazy">
        ${disc ? `<span class="badge badge-off">${disc}% OFF</span>` : p.featured ? '<span class="badge badge-feat">Featured</span>' : ''}
      </div>
      <div class="product-info">
        <div class="product-brand">${p.brand}</div>
        <div class="product-name">${p.name}</div>
        ${p.frameType ? `<div class="product-sub">${p.frameType} · ${p.color}</div>` : `<div class="product-sub">${p.color}</div>`}
        <div class="stars">${starsHTML(p.rating)} <span>(${p.reviews})</span></div>
        <div class="price-row">
          <div>
            <span class="price-current">Rs. ${p.price.toLocaleString('en-IN')}</span>
            ${p.originalPrice ? `<span class="price-old">Rs. ${p.originalPrice.toLocaleString('en-IN')}</span>` : ''}
          </div>
        </div>
        <button class="add-to-cart-btn" onclick="event.stopPropagation(); handleAddToCart(${p.id}, this)">
          🛒 Add to Cart
        </button>
      </div>
    </div>`;
}
function handleAddToCart(id, btn) {
  const product = PRODUCTS.find(p => p.id === id);
  if (!product) return;
  addToCart(product);
  btn.textContent = '✓ Added!';
  btn.classList.add('added');
  setTimeout(() => {
    btn.innerHTML = '🛒 Add to Cart';
    btn.classList.remove('added');
  }, 1600);
}
function initHomePage() {
  const grid = document.getElementById('featured-grid');
  if (grid) {
    const featured = PRODUCTS.filter(p => p.featured).slice(0, 8);
    grid.innerHTML = featured.map((p, i) => productCardHTML(p, i)).join('');
  }
}
function initProductsPage() {
  const params = new URLSearchParams(window.location.search);
  const initCat = params.get('cat') || '';
  const initSearch = params.get('q') || '';
  let selectedCat = initCat;
  let searchQuery = initSearch;
  const grid = document.getElementById('products-grid');
  const countEl = document.getElementById('product-count');
  const titleEl = document.getElementById('products-title');
  function renderProducts() {
    let list = [...PRODUCTS];
    if (selectedCat) list = list.filter(p => p.category === selectedCat);
    if (searchQuery) list = list.filter(p => p.name.toLowerCase().includes(searchQuery.toLowerCase()) || p.brand.toLowerCase().includes(searchQuery.toLowerCase()));
    if (countEl) countEl.textContent = `${list.length} products`;
    if (titleEl) titleEl.textContent = selectedCat || 'All Eyewear';
    if (!grid) return;
    if (list.length === 0) {
      grid.innerHTML = `<div class="empty-state" style="grid-column:1/-1"><div class="empty-icon">🔍</div><h2>No products found</h2></div>`;
    } else {
      grid.innerHTML = list.map((p, i) => productCardHTML(p, i)).join('');
    }
    document.querySelectorAll('.filter-btn[data-cat]').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.cat === selectedCat);
    });
  }
  document.querySelectorAll('.filter-btn[data-cat]').forEach(btn => {
    btn.addEventListener('click', () => {
      selectedCat = btn.dataset.cat;
      renderProducts();
    });
  });
  renderProducts();
}
function renderCartPage() {
  const cart = getCart();
  const container = document.getElementById('cart-items');
  const subtotalEl = document.getElementById('cart-subtotal');
  const totalEl = document.getElementById('cart-total');
  const emptyEl = document.getElementById('cart-empty');
  const mainEl = document.getElementById('cart-main');
  if (!container) return;
  const subtotal = cart.reduce((s, i) => s + i.price * i.qty, 0);
  const delivery = subtotal >= 999 ? 0 : 99;
  const total = subtotal + delivery;
  if (cart.length === 0) {
    if (emptyEl) emptyEl.style.display = 'block';
    if (mainEl) mainEl.style.display = 'none';
    return;
  }
  if (emptyEl) emptyEl.style.display = 'none';
  if (mainEl) mainEl.style.display = 'grid';
  container.innerHTML = cart.map(item => `
    <div class="cart-item">
      <img class="cart-item-img" src="${item.img}" alt="${item.name}">
      <div class="cart-item-details">
        <h3>${item.name}</h3>
        <p>${item.brand}</p>
        <div class="cart-qty">
          <button onclick="updateQty(${item.id}, -1)">−</button>
          <span>${item.qty}</span>
          <button onclick="updateQty(${item.id}, +1)">+</button>
        </div>
      </div>
      <div>
        <div class="cart-item-price">Rs. ${(item.price * item.qty).toLocaleString('en-IN')}</div>
      </div>
      <button class="remove-btn" onclick="removeFromCart(${item.id}); renderCartPage();">✕</button>
    </div>
  `).join('');
  if (subtotalEl) subtotalEl.textContent = `Rs. ${subtotal.toLocaleString('en-IN')}`;
  if (totalEl) totalEl.textContent = `Rs. ${total.toLocaleString('en-IN')}`;
  
  updateCartBadge();
}
document.addEventListener('DOMContentLoaded', function () {
  updateCartBadge();
  const body = document.body;
  if (body.dataset.page === 'home')     initHomePage();
  if (body.dataset.page === 'products') initProductsPage();
  if (body.dataset.page === 'cart')     renderCartPage();
});