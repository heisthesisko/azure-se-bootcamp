#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00_prereqs.sh"
# Create a custom daily policy with 30-day retention
az backup policy create --name "daily30" -g "$RG_NAME" -v "$RSV_NAME" --workload-type VM   --policy "{\"schedulePolicy\":{\"scheduleRunFrequency\":\"Daily\",\"scheduleRunTimes\":[\"2024-01-01T02:00:00Z\"]},\"retentionPolicy\":{\"retentionPolicyType\":\"LongTermRetentionPolicy\",\"dailySchedule\":{\"retentionTimes\":[\"2024-01-01T02:00:00Z\"],\"retentionDuration\":{\"count\":30,\"durationType\":\"Days\"}}}}"
