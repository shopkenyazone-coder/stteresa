<?php
declare(strict_types=1);

require __DIR__ . '/src/bootstrap.php';

$navActive         = 'admissions';
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
  <title>Admissions | St. Teresa Kanyange Academy</title>
  <meta name="description" content="Apply to St. Teresa Kanyange Academy. Learn about our admissions process, fees, and bursaries.">
  <link rel="stylesheet" href="css/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<?php require __DIR__ . '/partials/site-header.php'; ?>

  <section class="page-hero">
    <div class="container">
      <h2>Admissions</h2>
      <p class="breadcrumb"><a href="index.php">Home</a><span>/</span>Admissions</p>
    </div>
  </section>

  <section class="section">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Join Our Family</span>
        <h2>Begin Your St. Teresa Kanyange Journey</h2>
        <p>We welcome families of all backgrounds who share our commitment to faith-based education. Contact the school office or visit us to arrange a campus tour and learn how to join our community.</p>
      </div>
    </div>
  </section>

  <section class="section section-alt">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Tuition &amp; Aid</span>
        <h2>An Investment in Their Future</h2>
        <p>Clear, transparent fees for every level, with bursary guidance available from the school office.</p>
      </div>
      <div class="cards-grid">
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-child"></i></div>
          <div class="card-body">
            <h3>Pre-Primary</h3>
            <p><strong style="font-size:1.6rem;color:var(--navy);display:block;margin:10px 0">Ksh 8,500</strong>per year</p>
            <p>PP1 &ndash; PP2. Includes materials, lunch, and enrichment activities.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-book"></i></div>
          <div class="card-body">
            <h3>Primary &amp; Junior</h3>
            <p><strong style="font-size:1.6rem;color:var(--navy);display:block;margin:10px 0">Ksh 12,500</strong>per year</p>
            <p>Grade 1 &ndash; Grade 9. Includes technology fee, sports, and field trips.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-graduation-cap"></i></div>
          <div class="card-body">
            <h3>Senior School</h3>
            <p><strong style="font-size:1.6rem;color:var(--navy);display:block;margin:10px 0">Ksh 16,000</strong>per year</p>
            <p>Grade 10 &ndash; Grade 12. Includes CBC pathways, career guidance, and laboratory fees.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="section">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Questions</span>
        <h2>Frequently Asked Questions</h2>
        <p>Find answers to the questions families ask us most often about admissions.</p>
      </div>
      <div class="faq-list reveal">
        <div class="faq-item">
          <button class="faq-question">
            What are the application deadlines?
            <span class="toggle">+</span>
          </button>
          <div class="faq-answer">
            <p>Priority applications are due in January for the Term 1 intake. However, we accept applications on a rolling basis throughout the year as space permits. Early application is encouraged for the best placement opportunities.</p>
          </div>
        </div>
        <div class="faq-item">
          <button class="faq-question">
            Do students need to be Catholic to apply?
            <span class="toggle">+</span>
          </button>
          <div class="faq-answer">
            <p>No. While we are a Catholic school and all students participate in religion classes and campus ministry activities, we welcome students and families of all faith backgrounds. What we ask is respect for our mission and values.</p>
          </div>
        </div>
        <div class="faq-item">
          <button class="faq-question">
            What does the admissions assessment involve?
            <span class="toggle">+</span>
          </button>
          <div class="faq-answer">
            <p>The assessment is age-appropriate and designed to understand each student's strengths and learning style &mdash; not to exclude. Younger students complete a readiness screening, while older students take a diagnostic assessment in reading and math. Every applicant also enjoys a shadow day on campus.</p>
          </div>
        </div>
        <div class="faq-item">
          <button class="faq-question">
            Can my child transfer mid-year?
            <span class="toggle">+</span>
          </button>
          <div class="faq-answer">
            <p>Absolutely. We welcome mid-year transfers when space is available. Our counseling team helps new students transition smoothly, and teachers provide personalized support to ensure academic success.</p>
          </div>
        </div>
        <div class="faq-item">
          <button class="faq-question">
            What extracurriculars are offered?
            <span class="toggle">+</span>
          </button>
          <div class="faq-answer">
            <p>We offer school sports teams in football, volleyball, basketball, netball and athletics, robotics and coding clubs, drama, choir, student council, Scouts, St. John Ambulance, Campus Ministry, and service clubs. There's something for every passion!</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="cta-banner">
    <div class="container">
      <h2>Ready to Apply?</h2>
      <p>Take the first step toward a transformative education. Our admissions team is here to guide you every step of the way.</p>
      <div class="hero-buttons">
        <a href="contact.php" class="btn btn-primary">Start Your Application</a>
        <a href="contact.php" class="btn btn-outline">Request Information</a>
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
