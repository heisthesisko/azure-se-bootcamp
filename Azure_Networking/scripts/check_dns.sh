#!/usr/bin/env bash
set -euo pipefail
host="${1:-www.microsoft.com}"
echo "Resolving $host..."
nslookup "$host" || dig +short "$host" || getent hosts "$host"
