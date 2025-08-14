#!/usr/bin/env bash
set -euo pipefail
OUTDIR=${1:-"./mockdata"}
mkdir -p "$OUTDIR"
cat > "$OUTDIR/patients.csv" <<'CSV'
patient_id,first_name,last_name,dob,gender,member_id
1001,Ada,Lovelace,1815-12-10,F,PLN12345
1002,Alan,Turing,1912-06-23,M,PLN99999
1003,Grace,Hopper,1906-12-09,F,PLN77777
CSV
cat > "$OUTDIR/claims.json" <<'JSON'
[
  {"claimId":"C-001","patientId":1001,"cpt":"99213","icd10":"I10","amount":125.00,"status":"PAID"},
  {"claimId":"C-002","patientId":1002,"cpt":"70450","icd10":"S06.0X0A","amount":880.00,"status":"PENDING"}
]
JSON
echo "Mock ePHI written to $OUTDIR"
