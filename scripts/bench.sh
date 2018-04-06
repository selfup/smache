#!/usr/bin/env bash

SMACHE_LOG_FILE=.results.smache.log
PUB_SUB_LOG_FILE=.results.ps.log
MITIGATOR_LOG_FILE=.results.mitigator.log

function cflag () {
  if [ "$1" == "-c" ]
  then
    echo "--> entire benchmark output: "
  else
    git checkout -- $SMACHE_LOG_FILE
    git checkout -- $PUB_SUB_LOG_FILE
    git checkout -- $MITIGATOR_LOG_FILE
  fi
}

# if you pass the -c flag
# the script will keep changes in git for the logfile

ab \
  -n 20000 \
  -c 200 \
  -k -v 1 \
  -H "Accept-Encoding: gzip, deflate" \
  -T "application/json" \
  -p ./scripts/bench.data.json http://0.0.0.0:1234/api > $SMACHE_LOG_FILE \
  && echo "" \
  && echo "--> results:
    $(grep seconds $SMACHE_LOG_FILE)
    $(grep -w second $SMACHE_LOG_FILE)
  " \
  && cflag $1 \
  && ab \
    -n 20000 \
    -c 200 \
    -k -v 1 \
    "http://0.0.0.0:4001/api/" > $PUB_SUB_LOG_FILE \
    && echo "" \
    && echo "--> results:
      $(grep seconds $PUB_SUB_LOG_FILE)
      $(grep -w second $PUB_SUB_LOG_FILE)
    " \
  && cflag $1 \
  && ab \
    -n 20000 \
    -c 400 \
    -k -v 1 \
    "http://0.0.0.0:8081/" > $MITIGATOR_LOG_FILE \
    && echo "" \
    && echo "--> results:
      $(grep seconds $MITIGATOR_LOG_FILE)
      $(grep -w second $MITIGATOR_LOG_FILE)
    " \
    && cflag $1 \
