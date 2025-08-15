<?php
// Simple FHIR GET probe (unauthenticated mock or public test server only)
// DO NOT use for real PHI. For AHDS FHIR, use Managed Identity + audience token.
$fhir_base = getenv('FHIR_BASE') ?: 'https://hapi.fhir.org/baseR4';
$resource = 'Patient?_count=1';
$url = rtrim($fhir_base,'/') . '/' . $resource;
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 10);
$resp = curl_exec($ch);
if (curl_errno($ch)) { echo "CURL error: " . curl_error($ch); exit; }
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);
header('Content-Type: application/json');
echo json_encode(["url"=>$url, "http_code"=>$code, "snippet"=>substr($resp,0,2000)]);
