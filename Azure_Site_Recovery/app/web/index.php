<?php
$bundlePath = __DIR__ . '/../../assets/mock_data/patients.json';
$bundle = file_exists($bundlePath) ? json_decode(file_get_contents($bundlePath), true) : null;
?><!DOCTYPE html><html><head><meta charset="utf-8"><title>FHIR Viewer (Training)</title>
<style>body{font-family:Arial;margin:20px}table{border-collapse:collapse;width:100%}th,td{border:1px solid #ddd;padding:6px}th{background:#f6f6f6}</style>
</head><body><h1>FHIR Bundle Viewer (Synthetic)</h1>
<?php if(!$bundle){ echo "<p>No data. Run <code>python3 scripts/mock_ephi_generator.py</code>.</p>"; } else {
echo "<table><thead><tr><th>MRN</th><th>Name</th><th>Gender</th><th>Obs</th><th>LOINC</th><th>Value</th><th>Unit</th><th>Time</th></tr></thead><tbody>";
$pts=[]; foreach($bundle['entry'] as $e){ if($e['resource']['resourceType']==='Patient'){ $p=$e['resource']; $pts[$p['id']]=$p; } }
foreach($bundle['entry'] as $e){ $r=$e['resource']; if($r['resourceType']==='Observation'){ $pid=str_replace('Patient/','',$r['subject']['reference']); $p=$pts[$pid];
$mrn=$p['identifier'][0]['value']; $name=$p['name'][0]['given'][0].' '.$p['name'][0]['family']; $gender=$p['gender']; $code=$r['code']['coding'][0]['code']; $disp=$r['code']['coding'][0]['display'];
$val=$r['valueQuantity']['value']; $unit=$r['valueQuantity']['unit']; $eff=$r['effectiveDateTime'];
echo "<tr><td>$mrn</td><td>$name</td><td>$gender</td><td>$disp</td><td>$code</td><td>$val</td><td>$unit</td><td>$eff</td></tr>"; } }
echo "</tbody></table>"; } ?>
</body></html>