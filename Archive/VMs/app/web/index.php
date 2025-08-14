<?php
// Simple Patient Intake (training only; do not use in production as-is)
// Important: Avoid logging PHI. Sanitize inputs. Use HTTPS and WAF/NSG in production.
require_once "db.php";
$success = false; $err = "";

function sanitize($s) {
  return htmlspecialchars(trim($s), ENT_QUOTES, 'UTF-8');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $mrn = sanitize($_POST['mrn'] ?? "");
  $first = sanitize($_POST['first_name'] ?? "");
  $last = sanitize($_POST['last_name'] ?? "");
  $dob = sanitize($_POST['dob'] ?? "");
  $symp = sanitize($_POST['symptoms'] ?? "");
  $triage = sanitize($_POST['triage_level'] ?? "P3");

  if (!$mrn || !$first || !$last || !$dob) {
    $err = "Missing required fields.";
  } else {
    try {
      $pdo->beginTransaction();
      $stmt = $pdo->prepare("INSERT INTO health.patients (mrn, first_name, last_name, dob) VALUES (:mrn,:first,:last,:dob)
                             ON CONFLICT (mrn) DO UPDATE SET first_name=EXCLUDED.first_name, last_name=EXCLUDED.last_name, dob=EXCLUDED.dob
                             RETURNING patient_id;");
      $stmt->execute([':mrn'=>$mrn, ':first'=>$first, ':last'=>$last, ':dob'=>$dob]);
      $pid = $stmt->fetchColumn();
      $stmt2 = $pdo->prepare("INSERT INTO health.intake_forms (patient_id, symptoms, triage_level) VALUES (:pid,:symp,:triage);");
      $stmt2->execute([':pid'=>$pid, ':symp'=>$symp, ':triage'=>$triage]);
      $pdo->commit();
      $success = true;
    } catch (Exception $e) {
      $pdo->rollBack();
      $err = "Failed to submit intake.";
      error_log("Intake error: " . $e->getMessage());
    }
  }
}
?>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Healthcare Intake (Training)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    body{font-family:Arial, sans-serif; margin:2rem; max-width:720px;}
    label{display:block; margin:.5rem 0 .25rem; font-weight:bold;}
    input, textarea, select{width:100%; padding:.5rem;}
    .card{border:1px solid #ccc; padding:1rem; border-radius:.5rem;}
    .ok{color:green;} .err{color:#b00;}
  </style>
</head>
<body>
  <h1>Patient Intake (Training)</h1>
  <div class="card">
    <?php if ($success): ?>
      <p class="ok">Intake submitted. Thank you.</p>
    <?php elseif ($err): ?>
      <p class="err"><?= $err ?></p>
    <?php endif; ?>
    <form method="post">
      <label>MRN</label><input name="mrn" required />
      <label>First Name</label><input name="first_name" required />
      <label>Last Name</label><input name="last_name" required />
      <label>Date of Birth</label><input type="date" name="dob" required />
      <label>Symptoms</label><textarea name="symptoms" rows="3"></textarea>
      <label>Triage</label>
      <select name="triage_level">
        <option value="P1">P1 (Immediate)</option>
        <option value="P2">P2 (Urgent)</option>
        <option value="P3" selected>P3 (Standard)</option>
      </select>
      <button type="submit" style="margin-top:1rem;">Submit</button>
    </form>
  </div>
  <p style="margin-top:1rem; font-size:.9rem;">
    Training-only sample. Do not store real PHI. Use TLS, WAF, private endpoints, and audit logging in production.
  </p>
</body>
</html>
