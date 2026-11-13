<?php
/**
 * Image upload endpoint (secured).
 *
 * Requires a signed-in user and a valid CSRF token. Validates the real
 * MIME type, the extension, the decoded image and the size before saving
 * into assets/ under a random filename.
 *
 * PHP 8.2+
 */

declare(strict_types=1);

require __DIR__ . '/src/bootstrap.php';

use STA\Auth;
use STA\Config;
use STA\Csrf;
use STA\Database;
use STA\Response;

ini_set('display_errors', '0');

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    Response::json(['ok' => false, 'error' => 'Method not allowed. Use POST.'], 405);
}

$user = Auth::requireUser([], true);

$token = sta_json_header_token();

if ($token === '' && isset($_POST['csrf_token']) && is_string($_POST['csrf_token'])) {
    $token = $_POST['csrf_token'];
}

Csrf::requireValid($token);

if (!isset($_FILES['image']) || !is_array($_FILES['image'])) {
    Response::json(['ok' => false, 'error' => 'No image was uploaded.'], 400);
}

$file = $_FILES['image'];
$error = (int) ($file['error'] ?? UPLOAD_ERR_NO_FILE);

if ($error !== UPLOAD_ERR_OK) {
    $messages = [
        UPLOAD_ERR_INI_SIZE   => 'The image is larger than the server upload limit.',
        UPLOAD_ERR_FORM_SIZE  => 'The image is larger than the allowed upload size.',
        UPLOAD_ERR_PARTIAL    => 'The image was only partially uploaded. Please try again.',
        UPLOAD_ERR_NO_FILE    => 'No image was uploaded.',
        UPLOAD_ERR_NO_TMP_DIR => 'The server upload folder is unavailable.',
        UPLOAD_ERR_CANT_WRITE => 'The server could not write the uploaded image.',
        UPLOAD_ERR_EXTENSION  => 'The upload was stopped by a server extension.',
    ];

    Response::json(['ok' => false, 'error' => $messages[$error] ?? 'The image could not be uploaded.'], 400);
}

$tmpPath = (string) ($file['tmp_name'] ?? '');
$size = (int) ($file['size'] ?? 0);
$maxBytes = (int) Config::get('uploads.max_bytes', 8 * 1024 * 1024);

if ($tmpPath === '' || !is_uploaded_file($tmpPath)) {
    Response::json(['ok' => false, 'error' => 'The upload could not be verified.'], 400);
}

if ($size <= 0 || $size > $maxBytes) {
    Response::json(['ok' => false, 'error' => 'Images must be between 1 byte and 8 MB.'], 413);
}

/* Validate the extension supplied by the browser as well as the real MIME. */
$originalName = (string) ($file['name'] ?? '');
$originalExtension = strtolower((string) pathinfo($originalName, PATHINFO_EXTENSION));
$allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

if ($originalExtension !== '' && !in_array($originalExtension, $allowedExtensions, true)) {
    Response::json(['ok' => false, 'error' => 'Only JPG, PNG, GIF and WebP images are allowed.'], 415);
}

/* Verify the real content type, never trust the browser-supplied one. */
$mime = '';

if (class_exists('finfo')) {
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $detected = $finfo->file($tmpPath);
    $mime = is_string($detected) ? $detected : '';
} elseif (function_exists('mime_content_type')) {
    $mime = (string) mime_content_type($tmpPath);
}

$allowed = Config::get('uploads.mime_types', []);

if (!is_array($allowed) || !isset($allowed[$mime])) {
    Response::json(['ok' => false, 'error' => 'Only JPG, PNG, GIF and WebP images are allowed.'], 415);
}

/* Confirm the file really is a decodable image and that its type agrees. */
$info = @getimagesize($tmpPath);
$typeMap = [
    IMAGETYPE_JPEG => 'image/jpeg',
    IMAGETYPE_PNG  => 'image/png',
    IMAGETYPE_GIF  => 'image/gif',
    IMAGETYPE_WEBP => 'image/webp',
];

if (!$info || !isset($info[2], $typeMap[$info[2]]) || $typeMap[$info[2]] !== $mime) {
    Response::json(['ok' => false, 'error' => 'The uploaded file is not a valid image.'], 415);
}

$assetsDir = rtrim((string) Config::get('uploads.dir', __DIR__ . DIRECTORY_SEPARATOR . 'assets'), DIRECTORY_SEPARATOR);

if (!is_dir($assetsDir) && !mkdir($assetsDir, 0755, true) && !is_dir($assetsDir)) {
    Response::json(['ok' => false, 'error' => 'The assets folder could not be created.'], 500);
}

if (!is_writable($assetsDir)) {
    Response::json(['ok' => false, 'error' => 'The assets folder is not writable.'], 500);
}

$extension = (string) $allowed[$mime];
$filename = 'img_' . date('Ymd_His') . '_' . bin2hex(random_bytes(10)) . '.' . $extension;
$destination = $assetsDir . DIRECTORY_SEPARATOR . $filename;
$relative = 'assets/' . $filename;

if (!move_uploaded_file($tmpPath, $destination)) {
    Response::json(['ok' => false, 'error' => 'The image could not be saved.'], 500);
}

@chmod($destination, 0644);

try {
    Database::insert('media', [
        'filename'    => $filename,
        'path'        => $relative,
        'mime'        => $mime,
        'size'        => $size,
        'kind'        => 'image',
        'uploaded_by' => (int) $user['id'],
        'is_demo'     => 0,
    ]);
} catch (Throwable $e) {
    error_log('Could not register uploaded media: ' . $e->getMessage());
}

Auth::audit('media.upload', 'Uploaded ' . $filename . ' (' . $size . ' bytes)', (int) $user['id']);

Response::json([
    'ok'   => true,
    'path' => $relative,
    'url'  => $relative,
    'name' => $filename,
    'size' => $size,
    'mime' => $mime,
]);
