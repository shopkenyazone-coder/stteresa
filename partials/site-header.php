<?php

declare(strict_types=1);

/**
 * Public site header, top bar and navigation.
 *
 * Variables supplied by each page (all optional):
 *   $navActive         home|about|academics|admissions|contact
 *   $brandCrest        short crest text inside the logo (STK on the home page)
 *   $showTopPortalLink show the "Portal Login" link in the top bar (home page)
 */

$navActive         = $navActive ?? '';
$brandCrest        = $brandCrest ?? 'ST';
$showTopPortalLink = $showTopPortalLink ?? false;

$navLinks = [
    'home'       => ['index.php', 'Home'],
    'about'      => ['about.php', 'About'],
    'academics'  => ['academics.php', 'Academics'],
    'admissions' => ['admissions.php', 'Admissions'],
    'contact'    => ['contact.php', 'Contact'],
    'portal'     => ['admin/login.php', 'Portal Login'],
];
?>
  <div class="top-bar">
    <div class="container">
      <div class="top-bar-left">
        <span><i class="fas fa-phone"></i> +254 700 131515</span>
        <span><i class="fas fa-envelope"></i> saintlykids@gmail.com</span>
      </div>
      <div class="top-bar-right">
<?php if ($showTopPortalLink): ?>
        <a href="admin/login.php"><i class="fas fa-right-to-bracket"></i> Portal Login</a>
<?php endif; ?>
        <a href="admin/login.php">Student Portal</a>
        <a href="contact.php">Careers</a>
        <a href="contact.php">Give</a>
      </div>
    </div>
  </div>

  <header class="header">
    <div class="container">
      <a href="index.php" class="brand">
        <div class="brand-crest"><?= sta_e($brandCrest) ?></div>
        <div class="brand-text">
          <h1>St. Teresa Kanyange Academy</h1>
          <span>Unity is Strength</span>
        </div>
      </a>
      <nav class="nav">
<?php foreach ($navLinks as $key => [$href, $label]): ?>
        <a href="<?= sta_e($href) ?>"<?= $navActive === $key ? ' class="active"' : '' ?>><?= sta_e($label) ?></a>
<?php endforeach; ?>
        <a href="admissions.php" class="btn-apply">Apply Now</a>
      </nav>
      <button class="hamburger" aria-label="Toggle menu">
        <span></span><span></span><span></span>
      </button>
    </div>
  </header>
  <div class="nav-overlay"></div>
