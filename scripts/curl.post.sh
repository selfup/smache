#!/usr/bin/env bash

if [ "$HOST" == "" ]
then
  HOST=localhost
fi

if [ "$1" == "" ] || [ "$2" == "" ]
then
  echo 'PLEASE PROVIDE $1 and $2 FOR PORTS'
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
  http://$HOST:$2/api/)
"
fi
