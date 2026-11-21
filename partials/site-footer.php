<?php

declare(strict_types=1);

/**
 * Public site footer.
 *
 * Variables supplied by each page (all optional):
 *   $footerPortalLink show "Portal Login" in Quick Links (home page)
 *   $showPoweredBy    show the SHOPIX credit line (every page except home)
 */

$footerPortalLink = $footerPortalLink ?? false;
$showPoweredBy    = $showPoweredBy ?? true;
?>
  <footer class="footer">
    <div class="container">
      <div class="footer-grid">
        <div class="footer-brand">
          <div class="brand">
            <div class="brand-crest">ST</div>
            <div class="brand-text">
              <h1 style="color:#fff;font-size:1.2rem">St. Teresa Kanyange Academy</h1>
              <span>Unity is Strength</span>
            </div>
          </div>
          <p>Nurturing young minds and inspiring hearts since 1989. A Catholic CBC school serving Pre-Primary (PP1) through Senior School (Grade 12).</p>
          <div class="social-links">
            <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
            <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
            <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
          </div>
        </div>
        <div>
          <h4>Quick Links</h4>
          <ul class="footer-links">
            <li><a href="index.php">Home</a></li>
            <li><a href="about.php">About Us</a></li>
            <li><a href="academics.php">Academics</a></li>
            <li><a href="admissions.php">Admissions</a></li>
            <li><a href="contact.php">Contact</a></li>
<?php if ($footerPortalLink): ?>
            <li><a href="admin/login.php">Portal Login</a></li>
<?php endif; ?>
          </ul>
        </div>
        <div>
          <h4>Resources</h4>
          <ul class="footer-links">
            <li><a href="admin/login.php">Student Portal</a></li>
            <li><a href="academics.php">Student Handbook</a></li>
            <li><a href="academics.php">Course Catalog</a></li>
            <li><a href="contact.php">Careers</a></li>
            <li><a href="contact.php">Give to St. Teresa</a></li>
          </ul>
        </div>
        <div>
          <h4>Contact Info</h4>
          <div class="footer-contact">
            <p><i class="fas fa-map-marker-alt"></i> Othaya Town, Nyeri County, Kenya</p>
            <p><i class="fas fa-phone"></i> +254 700 131515</p>
            <p><i class="fas fa-envelope"></i> saintlykids@gmail.com</p>
            <p><i class="fas fa-clock"></i> Office: Mon–Fri, 8:00 AM – 4:00 PM</p>
          </div>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2026 St. Teresa Academy. All Rights Reserved. | <a href="#">Privacy Policy</a> | <a href="#">Terms of Use</a></p>
<?php if ($showPoweredBy): ?>
        <p class="powered-by">Powered by <span class="pby-dot">&#9670;</span> <a class="pby-brand" href="https://shopixhub.co.ke/" target="_blank" rel="noopener" title="Visit SHOPIX HUB SOLUTION website"><strong>SHOPIX HUB SOLUTION</strong></a><br><span class="pby-sub">Website Design &amp; Development &mdash; <a href="tel:+254703626702">Contacts 0703626702</a></span></p>
<?php endif; ?>
      </div>
    </div>
  </footer>
