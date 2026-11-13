<?php
declare(strict_types=1);

require __DIR__ . '/src/bootstrap.php';

$navActive         = 'about';
$brandCrest        = 'ST';
$showTopPortalLink = false;
$footerPortalLink  = false;
$showPoweredBy     = true;
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/svg+xml" href="images/favicon.svg">
  <title>About Us | St. Teresa Kanyange Academy</title>
  <meta name="description" content="Learn about the history, mission, and values of St. Teresa Kanyange Academy.">
  <link rel="stylesheet" href="css/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<?php require __DIR__ . '/partials/site-header.php'; ?>

  <section class="page-hero">
    <div class="container">
      <h2>About St. Teresa Academy</h2>
      <p class="breadcrumb"><a href="index.php">Home</a><span>/</span>About</p>
    </div>
  </section>

  <section class="section">
    <div class="container">
      <div class="about-grid">
        <div class="about-image reveal">
          <img id="campusImage" src="https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80" alt="St. Teresa Academy campus">
          <div class="experience-badge">
            <span class="num">1962</span>
            <span class="txt">Founded</span>
          </div>
        </div>
        <div class="about-text reveal">
          <span class="eyebrow">Our History</span>
          <h2>Rooted in Faith, Growing in Excellence</h2>
          <p>St. Teresa Academy was founded in 1962 by the Sisters of St. Joseph with a simple but profound vision: to provide an exceptional education grounded in the Catholic faith.</p>
          <p>What began as a small parish school with 47 students has blossomed into a thriving community of over 850 students, serving families across the region with a tradition of academic excellence and spiritual formation that spans more than six decades.</p>
          <p>Our namesake, St. Teresa of Ávila, reminds us that education is not merely about filling the mind, but about setting hearts on fire with purpose and love.</p>
          <a href="admissions.php" class="btn btn-navy">Join Our Community</a>
        </div>
      </div>
    </div>
  </section>

  <section class="section section-alt">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Mission &amp; Vision</span>
        <h2>What We Stand For</h2>
        <p>Our mission and core values guide everything we do, from the classroom to the playing field to the community we serve.</p>
      </div>
      <div class="cards-grid">
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-bullseye"></i></div>
          <div class="card-body">
            <h3>Our Mission</h3>
            <p>To educate the whole person — mind, body, and spirit — forming Catholic leaders who excel academically, lead with integrity, and serve with compassion.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-eye"></i></div>
          <div class="card-body">
            <h3>Our Vision</h3>
            <p>To be a beacon of Catholic excellence, inspiring every student to discover their God-given gifts and use them to set the world ablaze with love.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-heart"></i></div>
          <div class="card-body">
            <h3>Our Values</h3>
            <p>Faith, Excellence, Integrity, Service, Community, and Respect — the pillars that shape our characters and our choices every single day.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="section">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Leadership</span>
        <h2>Meet Our Leadership Team</h2>
        <p>Our dedicated administrators bring decades of experience in education, faith formation, and community building.</p>
      </div>
      <div class="teachers-grid" id="leadershipGrid">
        <div class="teacher-card reveal">
          <div class="teacher-avatar"><i class="fas fa-user"></i></div>
          <div class="teacher-info">
            <h3>Mrs. Margaret O'Brien</h3>
            <span class="subject">Principal</span>
            <p>M.Ed., 28 years in Catholic education, leading with wisdom, faith, and an open heart.</p>
          </div>
        </div>
        <div class="teacher-card reveal">
          <div class="teacher-avatar"><i class="fas fa-user"></i></div>
          <div class="teacher-info">
            <h3>Fr. Thomas Brennan</h3>
            <span class="subject">Chaplain</span>
            <p>Pastor and spiritual father guiding our community in faith, prayer, and service.</p>
          </div>
        </div>
        <div class="teacher-card reveal">
          <div class="teacher-avatar"><i class="fas fa-user"></i></div>
          <div class="teacher-info">
            <h3>Mr. Anthony Rossi</h3>
            <span class="subject">Vice Principal, Academics</span>
            <p>M.A. Curriculum &amp; Instruction, championing rigorous and innovative learning.</p>
          </div>
        </div>
        <div class="teacher-card reveal">
          <div class="teacher-avatar"><i class="fas fa-user"></i></div>
          <div class="teacher-info">
            <h3>Mrs. Linda Vasquez</h3>
            <span class="subject">Director of Admissions</span>
            <p>Welcoming families and guiding them through every step of the admissions journey.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="cta-banner">
    <div class="container">
      <h2>Experience the St. Teresa Difference</h2>
      <p>Schedule a campus tour and see our mission in action. We can't wait to welcome you.</p>
      <div class="hero-buttons">
        <a href="contact.php" class="btn btn-primary">Schedule a Tour</a>
        <a href="admissions.php" class="btn btn-outline">Apply Now</a>
      </div>
    </div>
  </section>

<?php require __DIR__ . '/partials/site-footer.php'; ?>

  <button class="back-to-top" aria-label="Back to top"><i class="fas fa-arrow-up"></i></button>

  <script src="js/persist.js"></script>
<script src="js/upload.js"></script>
  <script src="js/images.js"></script>
  <script src="js/script.js"></script>
</body>
</html>
