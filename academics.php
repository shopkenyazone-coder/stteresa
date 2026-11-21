<?php
declare(strict_types=1);

require __DIR__ . '/src/bootstrap.php';

$navActive         = 'academics';
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
  <title>Academics | St. Teresa Kanyange Academy</title>
  <meta name="description" content="Explore academic programmes at St. Teresa Kanyange Academy from Pre-Primary (PP1) to Senior School (Grade 12), aligned to Kenya's Competency-Based Curriculum.">
  <link rel="stylesheet" href="css/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<?php require __DIR__ . '/partials/site-header.php'; ?>

  <section class="page-hero">
    <div class="container">
      <h2>Academic Programs</h2>
      <p class="breadcrumb"><a href="index.php">Home</a><span>/</span>Academics</p>
    </div>
  </section>

  <section class="section">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Pre-Primary through Senior School</span>
        <h2>A Complete Educational Journey</h2>
        <p>Our comprehensive programmes build on one another, creating a seamless path from early-years wonder to university- and career-ready confidence.</p>
      </div>
      <div class="programs-grid">
        <div class="program-card reveal">
          <div class="program-header">
            <h3>Pre-Primary</h3>
            <span class="grade-range">PP1 &ndash; PP2</span>
          </div>
          <div class="program-body">
            <ul>
              <li>Play-based, faith-centred CBC learning</li>
              <li>Small class sizes (max 16 learners)</li>
              <li>Social &amp; emotional development</li>
              <li>Introduction to prayer &amp; community</li>
              <li>Creative arts &amp; outdoor exploration</li>
            </ul>
            <a href="admissions.php">Apply Now <i class="fas fa-arrow-right"></i></a>
          </div>
        </div>
        <div class="program-card reveal">
          <div class="program-header">
            <h3>Primary School</h3>
            <span class="grade-range">Grade 1 &ndash; Grade 6</span>
          </div>
          <div class="program-body">
            <ul>
              <li>Lower Primary (Grade 1&ndash;3) &amp; Middle Primary (Grade 4&ndash;6)</li>
              <li>Strong foundation in literacy, Kiswahili &amp; numeracy</li>
              <li>Weekly religion &amp; service projects</li>
              <li>Art, music, PE &amp; Kiswahili enrichment</li>
              <li>Technology-integrated classrooms</li>
              <li>Reading buddies &amp; mentorship</li>
            </ul>
            <a href="admissions.php">Apply Now <i class="fas fa-arrow-right"></i></a>
          </div>
        </div>
        <div class="program-card reveal">
          <div class="program-header">
            <h3>Junior School</h3>
            <span class="grade-range">Grade 7 &ndash; Grade 9</span>
          </div>
          <div class="program-body">
            <ul>
              <li>Departmentalised instruction</li>
              <li>STEM, robotics &amp; coding elective track</li>
              <li>Leadership &amp; campus ministry</li>
              <li>Sports &amp; fine arts programmes</li>
              <li>Advisory &amp; mentorship programme</li>
            </ul>
            <a href="admissions.php">Apply Now <i class="fas fa-arrow-right"></i></a>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="section section-alt">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Senior School</span>
        <h2>CBC Pathways &amp; University Readiness</h2>
        <p>Our rigorous Senior School programme prepares students for success at universities and colleges in Kenya and abroad.</p>
      </div>
      <div class="cards-grid">
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-graduation-cap"></i></div>
          <div class="card-body">
            <h3>CBC Pathways</h3>
            <p>STEM, Social Sciences, and Arts &amp; Sports Science pathways leading to national assessments.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-university"></i></div>
          <div class="card-body">
            <h3>KNEC Assessments</h3>
            <p>Learners sit for national assessments at each level, including the KJSEA and the Senior School final examination.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-compass"></i></div>
          <div class="card-body">
            <h3>Career &amp; University Guidance</h3>
            <p>Dedicated counsellors guide families through university applications, HELB funding, and scholarship opportunities.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-code"></i></div>
          <div class="card-body">
            <h3>STEM &amp; Engineering</h3>
            <p>Robotics, computer science, engineering design, and biomedical science pathways.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-theater-masks"></i></div>
          <div class="card-body">
            <h3>Performing &amp; Visual Arts</h3>
            <p>Theater, concert band, jazz ensemble, choir, studio art, and digital media production.</p>
          </div>
        </div>
        <div class="card reveal">
          <div class="card-icon"><i class="fas fa-trophy"></i></div>
          <div class="card-body">
            <h3>Athletics</h3>
            <p>School teams competing at county and national levels in football, volleyball, basketball, netball, and athletics.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <section class="section">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Kenyan Education System</span>
        <h2>Our CBC Grade Structure</h2>
        <p>Our levels follow Kenya's Competency-Based Curriculum, from Pre-Primary through Senior School.</p>
      </div>
      <div class="table-wrapper reveal">
        <table>
          <thead>
            <tr>
              <th>Level</th>
              <th>Classes</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>Pre-Primary</td><td>PP1, PP2</td></tr>
            <tr><td>Lower Primary</td><td>Grade 1, Grade 2, Grade 3</td></tr>
            <tr><td>Middle Primary</td><td>Grade 4, Grade 5, Grade 6</td></tr>
            <tr><td>Junior School</td><td>Grade 7, Grade 8, Grade 9</td></tr>
            <tr><td>Senior School</td><td>Grade 10, Grade 11, Grade 12</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <section class="section">
    <div class="container">
      <div class="section-header reveal">
        <span class="eyebrow">Daily Schedule</span>
        <h2>A Day at St. Teresa Kanyange Academy</h2>
        <p>Our schedule balances rigorous academics with faith, arts, athletics, and time for rest and reflection.</p>
      </div>
      <div class="table-wrapper reveal">
        <table>
          <thead>
            <tr>
              <th>Time</th>
              <th>Activity</th>
              <th>Location</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>7:45 AM</td>
              <td>Morning Prayer &amp; Announcements</td>
              <td>Assembly Hall</td>
            </tr>
            <tr>
              <td>8:00 AM</td>
              <td>Homeroom</td>
              <td>Classrooms</td>
            </tr>
            <tr>
              <td>8:15 AM</td>
              <td>First Period</td>
              <td>Classrooms</td>
            </tr>
            <tr>
              <td>9:05 AM</td>
              <td>Second Period</td>
              <td>Classrooms</td>
            </tr>
            <tr>
              <td>9:55 AM</td>
              <td>Break / Snack</td>
              <td>Dining Hall</td>
            </tr>
            <tr>
              <td>10:10 AM</td>
              <td>Third Period</td>
              <td>Classrooms</td>
            </tr>
            <tr>
              <td>11:00 AM</td>
              <td>School Mass (Wednesdays)</td>
              <td>Chapel</td>
            </tr>
            <tr>
              <td>11:50 AM</td>
              <td>Lunch</td>
              <td>Dining Hall</td>
            </tr>
            <tr>
              <td>12:35 PM</td>
              <td>Fourth Period</td>
              <td>Classrooms</td>
            </tr>
            <tr>
              <td>1:25 PM</td>
              <td>Fifth Period / Electives</td>
              <td>Various</td>
            </tr>
            <tr>
              <td>2:15 PM</td>
              <td>Sixth Period / Athletics</td>
              <td>Various</td>
            </tr>
            <tr>
              <td>3:05 PM</td>
              <td>Dismissal</td>
              <td>Main Entrance</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>

  <section class="cta-banner">
    <div class="container">
      <h2>See Our Programs in Action</h2>
      <p>Visit a classroom, meet our teachers, and discover why students thrive at St. Teresa Academy.</p>
      <div class="hero-buttons">
        <a href="contact.php" class="btn btn-primary">Schedule a Visit</a>
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
