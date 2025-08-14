#!/bin/bash

# Config
API_KEY="YOUR_API_KEY"
FPM_STATUS_URL="http://127.0.0.1/fpm-status?json"
NEW_RELIC_API_URL="https://metric-api.eu.newrelic.com/metric/v1"
HOST_NAME="YOUR_HOSTNAME"

# Retrieve FPM status
data=$(curl -s "$FPM_STATUS_URL")

# Get values from output
idle=$(echo "$data" | jq '."idle processes"')
active=$(echo "$data" | jq '."active processes"')
total=$(echo "$data" | jq '."total processes"')

timestamp=$(date +%s)

# Generate JSON with metrics data 
read -r -d '' payload <<EOF
[{
"common": {"attributes": {"host": "${HOST_NAME}"}},
"metrics":
[
  { "name": "php_fpm.idle",   "type": "gauge", "value": $idle,   "timestamp": $timestamp },
  { "name": "php_fpm.active", "type": "gauge", "value": $active, "timestamp": $timestamp },
  { "name": "php_fpm.total",  "type": "gauge", "value": $total,  "timestamp": $timestamp }
]
}]
EOF

# Send data to New Relic API server
curl -k -H "Content-Type: application/json" \
     -H "Api-Key: ${API_KEY}" \
     -X POST ${NEW_RELIC_API_URL} \
     --data "$payload"

