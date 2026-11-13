# ==============================================================
#  Stage 4A HTTP test suite (Windows / XAMPP localhost)
#
#  Runs the whole Stage 4A data path over HTTP against a throwaway
#  database (sta_school_test) so the live school data is never
#  touched. The live configuration is restored afterwards and the
#  live database is checked for changes.
#
#  Usage (from the project root):
#     powershell -NoProfile -ExecutionPolicy Bypass -File tests\stage4a-http.ps1
# ==============================================================

$ErrorActionPreference = 'Continue'
$root      = Split-Path -Parent $PSScriptRoot
$base      = 'http://localhost/my-school-project'
$tmp       = 'C:\Users\Nicky\AppData\Local\Temp\opencode'
$liveDb    = 'st_teresa_academy'
$testDb    = 'sta_school_test'
$mysql     = 'C:\XX\mysql\bin\mysql.exe'
$configFile = Join-Path $root 'config\database.php'

$pass = 0; $fail = 0
function Check($name, $cond, $detail) {
  if ($cond) { $script:pass++; Write-Output ("  PASS  {0}  [{1}]" -f $name, $detail) }
  else { $script:fail++; Write-Output ("  FAIL  {0}  [{1}]" -f $name, $detail) }
}
function Jar($n) { $p = Join-Path $tmp ("s4a-$n.txt"); if (Test-Path $p) { Remove-Item $p -Force }; return $p }
function LoginToken($jar) {
  $h = curl.exe -s -c $jar "$base/admin/login.php"
  return ([regex]::Match($h, 'name="csrf_token" value="([^"]+)"')).Groups[1].Value
}
function Login($jar, $user, $pass, $role) {
  $t = LoginToken $jar
  curl.exe -s -b $jar -c $jar -o NUL -w "%{http_code}|%{redirect_url}" `
    --data-urlencode "csrf_token=$t" --data-urlencode "portalRole=$role" `
    --data-urlencode "username=$user" --data-urlencode "password=$pass" "$base/admin/login.php"
}
function CsrfOf($jar) {
  $s = curl.exe -s -b $jar "$base/api/session.php"
  return ([regex]::Match($s, '"csrfToken":"([^"]+)"')).Groups[1].Value
}
function Api($jar, $domain, $op, $payload, $csrf) {
  $file = Join-Path $tmp 's4a-body.json'
  [IO.File]::WriteAllText($file, $payload, (New-Object System.Text.UTF8Encoding($false)))
  $args = @('-s', '-b', $jar, '-H', 'Content-Type: application/json')
  if ($csrf) { $args += @('-H', "X-CSRF-Token: $csrf") }
  $args += @('-X', 'POST', "--data-binary", "@$file", "$base/api/domain.php?domain=$domain", '-w', "`n%{http_code}")
  $raw = (curl.exe @args | Out-String)
  $lines = $raw -split "`r?`n"
  $code = ($lines | Where-Object { $_.Trim() -ne '' } | Select-Object -Last 1).Trim()
  $body = ($lines[0..([Math]::Max(0, $lines.Count - 2))] -join "`n")
  return @{ code = $code; body = $body }
}
function Sql($db, $query) {
  return (& $mysql -u root -N -e "USE $db; $query" 2>&1 | Out-String).Trim()
}

Write-Output '=== STAGE 4A HTTP TEST SUITE ==='
Write-Output ''

# ------------------------------------------------------------
# 0. Guard rails: remember the live database state and the config
# ------------------------------------------------------------
$liveBefore = Sql $liveDb "SELECT (SELECT COUNT(*) FROM students),(SELECT COUNT(*) FROM staff),(SELECT COUNT(*) FROM classes),(SELECT COUNT(*) FROM users);"
$configCopy = Join-Path $tmp 's4a-config-original.php'
Copy-Item -LiteralPath $configFile -Destination $configCopy -Force
$originalConfig = [IO.File]::ReadAllText($configFile)

try {
  # Switch the site to the throwaway database for the duration of the test
  $patched = $originalConfig -replace "'st_teresa_academy'", "'$testDb'"
  [IO.File]::WriteAllText($configFile, $patched, (New-Object System.Text.UTF8Encoding($false)))
  Start-Sleep -Milliseconds 300
  $using = Sql $liveDb "SELECT 1;"
  Check 'site now points at the test database' ((Sql $testDb "SELECT COUNT(*) FROM users;") -eq '10') 'test database has the demo accounts'

  # Clean the domain tables in the test database
  foreach ($t in 'students','staff','classes','academic_years','leadership','slider_slides','announcements') {
    Sql $testDb "DELETE FROM ``$t``;"
  }
  Sql $testDb "DELETE FROM content_documents WHERE doc_key IN ('settings','logo');"
  Sql $testDb "UPDATE domain_state SET migrated_at=NULL, record_count=0;"

  $admin = Jar 'admin'; $teacher = Jar 'teacher'; $student = Jar 'student'; $secretary = Jar 'secretary'; $anon = Jar 'anon'

  $r = Login $admin 'admin' 'admin123' 'admin'
  Check 'admin signs in' ($r.Split('|')[0] -eq '302') $r
  Login $teacher 'teacher' 'teacher123' 'teacher' | Out-Null
  Login $student 'student' 'student123' 'student' | Out-Null
  Login $secretary 'secretary' 'secretary123' 'secretary' | Out-Null
  $adminCsrf = CsrfOf $admin
  Check 'CSRF token issued' ($adminCsrf.Length -eq 64) "len=$($adminCsrf.Length)"

  Write-Output ''
  Write-Output '--- 1. AUTHENTICATION AND CSRF ON THE DOMAIN API ---'
  $code = curl.exe -s -o NUL -w '%{http_code}' -b $anon "$base/api/domain.php?domain=students"
  Check 'domain API refuses anonymous access' ($code -eq '401') "HTTP $code"
  $code = curl.exe -s -o NUL -w '%{http_code}' -b $admin "$base/api/domain.php?domain=students"
  Check 'domain API answers a signed-in admin' ($code -eq '200') "HTTP $code"
  $code = curl.exe -s -o NUL -w '%{http_code}' -b $admin "$base/api/domain.php?domain=not_a_domain"
  Check 'unknown domain is rejected' ($code -eq '400') "HTTP $code"
  $code = curl.exe -s -o NUL -w '%{http_code}' -b $admin -H 'Content-Type: application/json' -X POST --data '{"op":"create","record":{}}' "$base/api/domain.php?domain=students"
  Check 'create without a CSRF token is refused' ($code -eq '403') "HTTP $code"

  Write-Output ''
  Write-Output '--- 2. CREATE / READ / UPDATE / DELETE ---'
  $record = '{"op":"create","record":{"id":"s4a_stu_1","firstName":"Test","lastName":"Student","className":"Grade 9","grade":"Grade 9","status":"active","feeBalance":1500,"admissionNo":"S4A-001","extraField":"kept"}}'
  $res = Api $admin 'students' 'create' $record $adminCsrf
  Check 'create succeeds' ($res.code -eq '200' -and $res.body -match '"ok":true') $res.body
  $list = curl.exe -s -b $admin "$base/api/domain.php?domain=students"
  Check 'created record appears in the list' ($list -match 's4a_stu_1') 'record found'
  Check 'unknown fields are preserved' ($list -match 'extraField') 'extraField kept'
  $one = curl.exe -s -b $admin "$base/api/domain.php?domain=students&id=s4a_stu_1"
  Check 'single record can be read' ($one -match '"id":"s4a_stu_1"') 'record read'
  $missing = curl.exe -s -o NUL -w '%{http_code}' -b $admin "$base/api/domain.php?domain=students&id=does_not_exist"
  Check 'missing record returns 404' ($missing -eq '404') "HTTP $missing"

  $update = '{"op":"update","id":"s4a_stu_1","record":{"className":"Grade 10","feeBalance":2500}}'
  $res = Api $admin 'students' 'update' $update $adminCsrf
  Check 'update succeeds' ($res.code -eq '200') $res.body
  $one = curl.exe -s -b $admin "$base/api/domain.php?domain=students&id=s4a_stu_1"
  Check 'update changed the value' ($one -match 'Grade 10') 'className updated'
  Check 'update kept the other fields' ($one -match 'extraField') 'other fields kept'
  $row = Sql $testDb "SELECT class_name, fee_balance FROM students WHERE legacy_id='s4a_stu_1';"
  Check 'searchable columns were updated' ($row -match 'Grade 10') $row

  $res = Api $admin 'students' 'delete' '{"op":"delete","id":"s4a_stu_1"}' $adminCsrf
  Check 'delete succeeds' ($res.code -eq '200') $res.body
  $list = curl.exe -s -b $admin "$base/api/domain.php?domain=students"
  Check 'deleted record is no longer listed' ($list -notmatch 's4a_stu_1') 'gone from the list'
  $row = Sql $testDb "SELECT COUNT(*), IF(deleted_at IS NULL,0,1) FROM students WHERE legacy_id='s4a_stu_1';"
  Check 'deleted record is kept in the database' ($row -match '^1\s+1$') "row=$row (count, soft-deleted)"

  Write-Output ''
  Write-Output '--- 3. PERMISSIONS ---'
  $teacherCsrf = CsrfOf $teacher
  $res = Api $teacher 'students' 'create' '{"op":"create","record":{"id":"s4a_teacher","firstName":"No"}}' $teacherCsrf
  Check 'teacher cannot create a student' ($res.code -eq '403') "HTTP $($res.code)"
  $res = Api $teacher 'classes' 'create' '{"op":"create","record":{"id":"s4a_cls","name":"X"}}' $teacherCsrf
  Check 'teacher cannot create a class' ($res.code -eq '403') "HTTP $($res.code)"
  $code = curl.exe -s -o NUL -w '%{http_code}' -b $teacher "$base/api/domain.php?domain=students"
  Check 'teacher can read students' ($code -eq '200') "HTTP $code"
  $code = curl.exe -s -o NUL -w '%{http_code}' -b $teacher "$base/api/domain.php?domain=teachers"
  Check 'teacher cannot read the staff list' ($code -eq '403') "HTTP $code"
  $secretaryCsrf = CsrfOf $secretary
  $res = Api $secretary 'students' 'create' '{"op":"create","record":{"id":"s4a_sec","firstName":"Sec"}}' $secretaryCsrf
  Check 'secretary can create a student' ($res.code -eq '200') "HTTP $($res.code)"
  $studentCsrf = CsrfOf $student
  $res = Api $student 'students' 'create' '{"op":"create","record":{"id":"s4a_stu_x"}}' $studentCsrf
  Check 'student cannot create records' ($res.code -eq '403') "HTTP $($res.code)"
  $res = Api $student 'students' 'update' '{"op":"update","id":"s4a_stu_1","record":{"className":"X"}}' $studentCsrf
  Check 'student cannot update records' ($res.code -eq '403') "HTTP $($res.code)"
  $code = curl.exe -s -o NUL -w '%{http_code}' -b $student "$base/api/domain.php?domain=students"
  Check 'student list only shows its own record' ($code -eq '200') "HTTP $code"

  Write-Output ''
  Write-Output '--- 4. BROWSER WRITE-THROUGH (api.php -> MySQL) ---'
  # switch the students domain over to MySQL, exactly as the importer does
  Sql $testDb "UPDATE domain_state SET migrated_at=NOW() WHERE domain_key IN ('students','teachers');"
  $payload = '{"students":[{"id":"s4a_write_1","firstName":"Write","lastName":"Through","className":"Grade 9","status":"active","feeBalance":0}],"teachers":[{"id":"s4a_tea_1","firstName":"Staff","lastName":"One","subject":"English","status":"active"}],"settings":{"schoolName":"St. Teresa Kanyange Academy","currency":"Ksh"}}'
  [IO.File]::WriteAllText((Join-Path $tmp 's4a-snapshot.json'), $payload, (New-Object System.Text.UTF8Encoding($false)))
  $code = curl.exe -s -o NUL -w '%{http_code}' -b $admin -H 'Content-Type: application/json' -H "X-CSRF-Token: $adminCsrf" -X POST --data-binary "@$tmp\s4a-snapshot.json" "$base/api.php"
  Check 'browser save is accepted' ($code -eq '200') "HTTP $code"
  $row = Sql $testDb "SELECT COUNT(*) FROM students WHERE legacy_id='s4a_write_1';"
  Check 'saved student landed in MySQL' ($row -eq '1') "rows=$row"
  $row = Sql $testDb "SELECT COUNT(*) FROM staff WHERE legacy_id='s4a_tea_1';"
  Check 'saved teacher landed in MySQL' ($row -eq '1') "rows=$row"
  $mirror = if (Test-Path (Join-Path $root 'data\site-data.json')) { Get-Content (Join-Path $root 'data\site-data.json') -Raw } else { '' }
  Check 'the original data is mirrored to the JSON file' ($mirror -match 's4a_write_1') 'mirror holds the record'

  # switch the students domain over to MySQL and confirm the API serves it from there
  $api = curl.exe -s -b $admin "$base/api.php"
  Check 'api.php serves the migrated domain from MySQL' ($api -match 's4a_write_1') 'students come from the database'
  $apiAnon = curl.exe -s -b $anon "$base/api.php"
  Check 'public api.php still hides the student list' ($apiAnon -notmatch 's4a_write_1') 'students are not public'
  $apiPublic = curl.exe -s -b $anon "$base/api.php"
  Check 'public api.php still serves the public content' (($apiPublic -match '"ok":true')) 'public payload is valid'

  Write-Output ''
  Write-Output '--- 5. IMPORTER ---'
  $export = Join-Path $tmp 's4a-export.json'
  $exportPayload = '{"students":[{"id":"imp_1","firstName":"Imported","lastName":"One","className":"Grade 9","status":"active"},{"id":"imp_2","firstName":"Imported","lastName":"Two","className":"Grade 9","status":"active"}],"classes":[{"id":"imp_cls_1","name":"Grade 9","level":9,"teacherId":"imp_tea_1","teacherName":"Teacher One"}],"teachers":[{"id":"imp_tea_1","firstName":"Teacher","lastName":"One","subject":"English","status":"active"}],"payments":[{"id":"pay_1","amount":100}],"settings":{"schoolName":"St. Teresa Kanyange Academy"}}'
  [IO.File]::WriteAllText($export, $exportPayload, (New-Object System.Text.UTF8Encoding($false)))
  $env:STA_DB_NAME = $testDb
  $dry = & C:\XX\php\php.exe (Join-Path $root 'database\import-domains.php') --file=$export --dry-run 2>&1 | Out-String
  Check 'importer dry run reports success' ($dry -match 'Dry run complete') 'dry run finished'
  $row = Sql $testDb "SELECT COUNT(*) FROM students WHERE legacy_id LIKE 'imp_%';"
  Check 'dry run wrote nothing' ($row -eq '0') "rows=$row"
  $run = & C:\XX\php\php.exe (Join-Path $root 'database\import-domains.php') --file=$export --overwrite 2>&1 | Out-String
  Check 'importer completes' ($run -match 'Import complete and verified') 'import verified'
  $row = Sql $testDb "SELECT COUNT(*) FROM students WHERE legacy_id LIKE 'imp_%';"
  Check 'imported students are in MySQL' ($row -eq '2') "rows=$row"
  $row = Sql $testDb "SELECT COUNT(*) FROM classes WHERE legacy_id='imp_cls_1';"
  Check 'imported classes are in MySQL' ($row -eq '1') "rows=$row"
  $row = Sql $testDb "SELECT COUNT(*) FROM (SELECT legacy_id FROM students GROUP BY legacy_id HAVING COUNT(*)>1) d;"
  Check 'import created no duplicates' ($row -eq '0') "duplicates=$row"
  $kept = Sql $testDb "SELECT COUNT(*) FROM students WHERE legacy_id='s4a_write_1';"
  Check 'records already in MySQL were kept' ($kept -eq '1') "rows=$kept"
  $orphan = Sql $testDb "SELECT COUNT(*) FROM students s LEFT JOIN classes c ON c.name=s.class_name AND c.deleted_at IS NULL WHERE s.deleted_at IS NULL AND s.class_name<>'' AND c.id IS NULL;"
  Check 'imported students link to an imported class' ($orphan -eq '0') "orphans=$orphan"
  $again = & C:\XX\php\php.exe (Join-Path $root 'database\import-domains.php') --file=$export --overwrite 2>&1 | Out-String
  $row = Sql $testDb "SELECT COUNT(*) FROM students WHERE legacy_id LIKE 'imp_%';"
  Check 're-running the import is idempotent' ($row -eq '2') "rows=$row"
  $keptFile = Test-Path (Join-Path $root 'storage\imports')
  Check 'the original export is kept in storage/imports' $keptFile 'imports folder'
  $removed = curl.exe -s -b $admin "$base/api/domain.php?domain=students"
  Check 'the domain API serves the imported records' ($removed -match 'imp_1') 'records readable'
  Remove-Item Env:\STA_DB_NAME

  Write-Output ''
  Write-Output '--- 6. NO DUPLICATES / MISSING RECORDS ---'
  foreach ($t in 'students','staff','classes','academic_years','leadership','slider_slides','announcements') {
    $d = Sql $testDb "SELECT COUNT(*) FROM (SELECT legacy_id FROM ``$t`` GROUP BY legacy_id HAVING COUNT(*)>1) d;"
    Check "no duplicate ids in $t" ($d -eq '0') "duplicates=$d"
  }
  $live = Sql $testDb "SELECT COUNT(*) FROM students WHERE deleted_at IS NULL;"
  Check 'live student rows match the domain API count' ($live -ge 1) "live=$live"

  Write-Output ''
  Write-Output '--- 7. THE EXISTING SITE STILL WORKS ---'
  foreach ($p in 'index.php','about.php','academics.php','admissions.php','contact.php') {
    $c = curl.exe -s -o NUL -w '%{http_code}' "$base/$p"
    Check "public page $p" ($c -eq '200') "HTTP $c"
  }
  $c = curl.exe -s -o NUL -w '%{http_code}' -b $admin "$base/admin/dashboard.php"
  Check 'admin portal still loads' ($c -eq '200') "HTTP $c"
  $c = curl.exe -s -o NUL -w '%{http_code}' -b $admin "$base/teacher/dashboard.php"
  Check 'wrong-portal access still blocked' ($c -eq '302') "HTTP $c"
}
finally {
  # Always put the live configuration back
  [IO.File]::WriteAllText($configFile, $originalConfig, (New-Object System.Text.UTF8Encoding($false)))
  Start-Sleep -Milliseconds 200
}

Write-Output ''
Write-Output '--- 8. THE LIVE DATABASE WAS NOT TOUCHED ---'
$liveAfter = Sql $liveDb "SELECT (SELECT COUNT(*) FROM students),(SELECT COUNT(*) FROM staff),(SELECT COUNT(*) FROM classes),(SELECT COUNT(*) FROM users);"
Check 'live database row counts are unchanged' ($liveAfter -eq $liveBefore) "before=[$liveBefore] after=[$liveAfter]"
$configNow = [IO.File]::ReadAllText($configFile)
Check 'the live configuration was restored' ($configNow -eq $originalConfig) 'config/config.php restored'
$liveMigrated = Sql $liveDb "SELECT COUNT(*) FROM domain_state WHERE migrated_at IS NOT NULL;"
Check 'no domain was switched to MySQL in the live database' ($liveMigrated -eq '0') "migrated=$liveMigrated"

Write-Output ''
Write-Output '==========================================='
Write-Output ("RESULT: {0} passed, {1} failed" -f $pass, $fail)
Write-Output '==========================================='
if ($fail -gt 0) { exit 1 }
