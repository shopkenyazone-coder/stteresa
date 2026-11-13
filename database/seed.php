<?php

declare(strict_types=1);

/**
 * Local sample data only.
 *
 * Creates demo accounts and a couple of demo contact messages so the
 * portal can be tested on localhost. Every seeded row is marked
 * is_demo = 1 and this script never updates or deletes production rows.
 *
 * Usage:
 *   php database/seed.php [--force] [--dry-run]
 *
 *   --force     refresh the password/name of existing demo accounts
 *   --dry-run   report what would be inserted, change nothing
 */

if (PHP_SAPI !== 'cli') {
    http_response_code(403);
    exit("This script can only be run from the command line.\n");
}

require dirname(__DIR__) . '/src/bootstrap.php';

use STA\Auth;
use STA\Database;

$options   = getopt('', ['force', 'dry-run', 'help']);
$force     = array_key_exists('force', $options);
$dryRun    = array_key_exists('dry-run', $options);

if (array_key_exists('help', $options)) {
    echo "Usage: php database/seed.php [--force] [--dry-run]\n";
    echo "Inserts clearly-marked demo accounts (is_demo = 1) only.\n";
    exit(0);
}

function line(string $text): void
{
    echo $text . PHP_EOL;
}

try {
    Database::pdo()->query('SELECT 1 FROM users LIMIT 1');
} catch (Throwable $e) {
    fwrite(STDERR, "The users table was not found. Import database/schema.sql first.\n");
    fwrite(STDERR, $e->getMessage() . "\n");
    exit(1);
}

$demoUsers = [
    ['admin',         'admin123',     'admin',         'System Administrator', 'admin@stteresaacademy.edu',       null,           null],
    ['headteacher',   'head123',      'headteacher',   'Sr. Catherine Marie',  'cmarie@stteresaacademy.edu',      null,           null],
    ['chiefexaminer', 'chief123',     'chiefexaminer', 'Mr. Anthony Rossi',    'arossi@stteresaacademy.edu',      'Mathematics',  null],
    ['secretary',     'secretary123', 'secretary',     'Ms. Linda Vasquez',    'lvasquez@stteresaacademy.edu',    null,           null],
    ['teacher',       'teacher123',   'teacher',       'Mrs. Margaret OBrien', 'mobrien@stteresaacademy.edu',     'Mathematics',  null],
    ['student',       'student123',   'student',       'John Smith',           'jsmith@student.stteresa.edu',     null,           'Grade 9'],
    ['storekeeper',   'store123',     'storekeeper',   'Mr. Peter Kamau',      'pkamau@stteresaacademy.edu',      null,           null],
    ['kitchenmanager', 'kitchen123',  'kitchenmanager', 'Ms. Grace Njeri',     'gnjeri@stteresaacademy.edu',      null,           null],
    ['uniformjunior', 'uniform123',   'storekeeper',   'Ms. Ruth Achieng',     'rachieng@stteresaacademy.edu',    null,           null],
    ['uniformacademy', 'uniform123',  'storekeeper',   'Mr. Samuel Otieno',    'sotieno@stteresaacademy.edu',     null,           null],
];

$inserted = 0;
$updated  = 0;
$skipped  = 0;

line($dryRun ? 'DRY RUN - no database changes will be made.' : 'Seeding local demo data...');

foreach ($demoUsers as [$username, $password, $role, $name, $email, $subject, $className]) {
    $existing = Database::one('SELECT id, is_demo FROM users WHERE username = ? LIMIT 1', [$username]);

    if ($existing !== null) {
        if ($force && (int) $existing['is_demo'] === 1) {
            if ($dryRun) {
                line("  would refresh demo account: {$username}");
            } else {
                Database::execute(
                    'UPDATE users SET password_hash = ?, legacy_password_hash = NULL, name = ?, email = ?, role = ?, subject = ? WHERE id = ? AND is_demo = 1',
                    [Auth::hashPassword($password), $name, $email, $role, $subject, (int) $existing['id']]
                );
            }
            $updated++;
        } else {
            line("  skipped existing account: {$username}");
            $skipped++;
        }
        continue;
    }

    if ($dryRun) {
        line("  would insert demo account: {$username} ({$role})");
        $inserted++;
        continue;
    }

    $id = Database::insert('users', [
        'legacy_id'        => 'seed-' . $username,
        'username'         => $username,
        'email'            => $email,
        'password_hash'    => Auth::hashPassword($password),
        'role'             => $role,
        'status'           => 'active',
        'name'             => $name,
        'subject'          => $subject,
        'class_name'       => $className,
        'must_change_password' => 0,
        'is_demo'          => 1,
    ]);

    line("  inserted demo account #{$id}: {$username} ({$role})");
    $inserted++;
}

$demoMessages = [
    [
        'legacy_id' => 'seed-contact-1',
        'name'      => 'Demo Parent',
        'email'     => 'parent.demo@example.com',
        'phone'     => '+254 700 000 001',
        'interest'  => 'Admissions',
        'message'   => 'Sample enquiry created by database/seed.php for local testing only.',
    ],
    [
        'legacy_id' => 'seed-contact-2',
        'name'      => 'Demo Visitor',
        'email'     => 'visitor.demo@example.com',
        'phone'     => '+254 700 000 002',
        'interest'  => 'General',
        'message'   => 'Second sample enquiry created for local testing only.',
    ],
];

foreach ($demoMessages as $message) {
    $existing = Database::one('SELECT id FROM contact_messages WHERE legacy_id = ? LIMIT 1', [$message['legacy_id']]);

    if ($existing !== null) {
        line('  skipped existing demo message: ' . $message['legacy_id']);
        $skipped++;
        continue;
    }

    if ($dryRun) {
        line('  would insert demo message: ' . $message['legacy_id']);
        $inserted++;
        continue;
    }

    $message['is_demo'] = 1;
    $message['status']  = 'new';
    Database::insert('contact_messages', $message);
    line('  inserted demo message: ' . $message['legacy_id']);
    $inserted++;
}

line('');
line(sprintf('Done. inserted=%d refreshed=%d skipped=%d', $inserted, $updated, $skipped));
line('All seeded rows are marked is_demo = 1 and are safe to remove before production.');
