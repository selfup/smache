#!/usr/bin/env bash

# requires ab (apache bench)
# comes pre-installed on macOS
# to install on linux visit: https://www.ndchost.com/wiki/apache/stress-testing-with-apache-benchmark
# unfortunately not available on windows :(

SMACHE_LOG_FILE=.results.smache.log
SMACHE_TWO_LOG_FILE=.results.smache.two.log

function run () {
  if [ "$1" == "m" ]
  then
    ab \
      -n 40000 \
      -c 400 \
      -k -v 1 \
      "http://0.0:8081/?key=1" > $MITIGATOR_LOG_FILE \
      && echo "" \
      && echo "--> results:
        $(grep seconds $MITIGATOR_LOG_FILE)
        $(grep -w second $MITIGATOR_LOG_FILE)
      "
  fi

  if [ "$1" == "" ]
  then
    ab \
    -n 20000 \
    -c 400 \
    -k -v 1 \
    -H "Accept-Encoding: gzip, deflate" \
    -T "application/json" \
    -p ./scripts/bench.data.one.json http://0.0:1234/api > $SMACHE_LOG_FILE \
    && echo "" \
    && echo "--> results:
      $(grep seconds $SMACHE_LOG_FILE)
      $(grep -w second $SMACHE_LOG_FILE)
    " \
    && ab \
      -n 20000 \
      -c 400 \
      -k -v 1 \
      -H "Accept-Encoding: gzip, deflate" \
      -T "application/json" \
      -p ./scripts/bench.data.two.json http://0.0:1234/api > $SMACHE_TWO_LOG_FILE \
      && echo "" \
      && echo "--> results:
        $(grep seconds $SMACHE_TWO_LOG_FILE)
        $(grep -w second $SMACHE_TWO_LOG_FILE)
      " \
    && ab \
      -n 2000 \
      -c 20 \
      -k -v 1 \
      "http://0.0:1234/api/?key=1" > $SMACHE_TWO_LOG_FILE \
      && echo "" \
      && echo "--> results:
        $(grep seconds $SMACHE_TWO_LOG_FILE)
        $(grep -w second $SMACHE_TWO_LOG_FILE)
      " \
    && ab \
      -n 2000 \
      -c 20 \
      -k -v 1 \
      "http://0.0:1234/api/?key=2" > $SMACHE_TWO_LOG_FILE \
      && echo "" \
      && echo "--> results:
        $(grep seconds $SMACHE_TWO_LOG_FILE)
        $(grep -w second $SMACHE_TWO_LOG_FILE)
      "
  fi

  if [ "$2" == "c" ]
  then
    git checkout -- $SMACHE_LOG_FILE
    git checkout -- $PUB_SUB_LOG_FILE
    git checkout -- $MITIGATOR_LOG_FILE
  fi
}

run $1 $2
