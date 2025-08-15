<?php
$FHIR_ENDPOINT = getenv('FHIR_ENDPOINT') ?: 'https://example.azurehealthcareapis.com/fhir';
$token = getenv('FHIR_BEARER_TOKEN') ?: '';
$patient = [
  "resourceType" => "Patient",
  "id" => "example",
  "name" => [["family" => "Doe", "given" => ["Jane"]]],
  "gender" => "female",
  "birthDate" => "1980-02-01"
];
$ch = curl_init($FHIR_ENDPOINT . "/Patient");
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($patient));
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/fhir+json", $token ? "Authorization: Bearer {$token}" : ""]);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$resp = curl_exec($ch);
$code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);
http_response_code($code); header("Content-Type: application/json"); echo $resp ?: json_encode(["status"=>$code,"message"=>"No response"]);
