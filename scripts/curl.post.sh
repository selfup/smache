#!/usr/bin/env bash

echo "
  $(curl \
    --fail --silent --show-error \
    -H "Content-Type: application/json" \
    -X POST -d @scripts/bench.data.one.json \
    http://localhost:$1/api/)
  $(curl \
    --fail --silent --show-error \
    -H "Content-Type: application/json" \
    -X POST -d @scripts/bench.data.two.json \
    http://localhost:$1/api/)
"
