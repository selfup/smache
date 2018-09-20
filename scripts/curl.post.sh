#!/usr/bin/env bash

if [ "$HOST" == "" ]
then
  HOST=localhost
fi

if [ "$1" == "" ]
then
  echo 'PLEASE PROVIDE $1 FOR LB PORT'
else
# odd spacing for output
echo "
$(curl \
  --fail --silent --show-error \
  -H "Content-Type: application/json" \
  -X POST -d @scripts/bench.data.one.json \
  http://$HOST:$1/api/)
$(curl \
  --fail --silent --show-error \
  -H "Content-Type: application/json" \
  -X POST -d @scripts/bench.data.two.json \
  http://$HOST:$1/api/)
$(curl \
  --fail --silent --show-error \
  -H "Content-Type: application/json" \
  -X POST -d @scripts/bench.data.three.json \
  http://$HOST:$1/api/)
$(curl \
  --fail --silent --show-error \
  -H "Content-Type: application/json" \
  -X POST -d @scripts/bench.data.four.json \
  http://$HOST:$1/api/)
$(curl \
  --fail --silent --show-error \
  -H "Content-Type: application/json" \
  -X POST -d @scripts/bench.data.five.json \
  http://$HOST:$1/api/)
$(curl \
  --fail --silent --show-error \
  -H "Content-Type: application/json" \
  -X POST -d @scripts/bench.data.six.json \
  http://$HOST:$1/api/)
$(curl \
  --fail --silent --show-error \
  -H "Content-Type: application/json" \
  -X POST -d @scripts/bench.data.seven.json \
  http://$HOST:$1/api/)
"
fi
