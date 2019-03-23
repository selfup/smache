#!/usr/bin/env bash

# requires ab (apache bench)
# comes pre-installed on macOS
# to install on linux visit: https://www.ndchost.com/wiki/apache/stress-testing-with-apache-benchmark
# unfortunately not available on windows :(

SMACHE_LOG_FILE=.results.smache.log
SMACHE_TWO_LOG_FILE=.results.smache.two.log
SMACHE_THREE_LOG_FILE=.results.smache.two.log
SMACHE_FOUR_LOG_FILE=.results.smache.two.log

if [ "$HOST" == "" ]
then
  echo "
    NO HOST PROVIDED
    DEFAULTING TO 0.0.0.0
    (LOCAL MACHINE)
  "
  HOST=0.0
fi

if [ "$1" == "" ] || [ "$2" == "" ]
then
  echo 'PLEASE PROVIDE $1 and $2 FOR PORTS'
else
  ab \
  -n 5000 \
  -c 100 \
  -k -v 1 \
  -H "Accept-Encoding: gzip, deflate" \
  -T "application/json" \
  -p ./scripts/json/bench.data.one.json http://$HOST:$1/api > $SMACHE_LOG_FILE \
  && echo "" \
  && echo "--> results:

    $(grep seconds $SMACHE_LOG_FILE)
    $(grep -w second $SMACHE_LOG_FILE)
    $(grep -w '50%' $SMACHE_LOG_FILE) ms
    $(grep -w '95%' $SMACHE_LOG_FILE) ms
    $(grep -w longest $SMACHE_LOG_FILE)
  " \
  && ab \
    -n 5000 \
    -c 100 \
    -k -v 1 \
    -H "Accept-Encoding: gzip, deflate" \
    -T "application/json" \
    -p ./scripts/json/bench.data.two.json http://$HOST:$1/api > $SMACHE_TWO_LOG_FILE \
    && echo "" \
    && echo "--> results:

    $(grep seconds $SMACHE_TWO_LOG_FILE)
    $(grep -w second $SMACHE_TWO_LOG_FILE)
    $(grep -w '50%' $SMACHE_TWO_LOG_FILE) ms
    $(grep -w '95%' $SMACHE_TWO_LOG_FILE) ms
    $(grep -w longest $SMACHE_TWO_LOG_FILE)
    " \
  && ab \
    -n 5000 \
    -c 100 \
    -k -v 1 \
    "http://$HOST:$1/api/?key=1" > $SMACHE_THREE_LOG_FILE \
    && echo "" \
    && echo "--> results:

    $(grep seconds $SMACHE_THREE_LOG_FILE)
    $(grep -w second $SMACHE_THREE_LOG_FILE)
    $(grep -w '50%' $SMACHE_THREE_LOG_FILE) ms
    $(grep -w '95%' $SMACHE_THREE_LOG_FILE) ms
    $(grep -w longest $SMACHE_THREE_LOG_FILE)
    " \
  && ab \
    -n 5000 \
    -c 100 \
    -k -v 1 \
    "http://$HOST:$2/api/?key=2" > $SMACHE_FOUR_LOG_FILE \
    && echo "" \
    && echo "--> results:

    $(grep seconds $SMACHE_FOUR_LOG_FILE)
    $(grep -w second $SMACHE_FOUR_LOG_FILE)
    $(grep -w '50%' $SMACHE_FOUR_LOG_FILE) ms
    $(grep -w '95%' $SMACHE_FOUR_LOG_FILE) ms
    $(grep -w longest $SMACHE_FOUR_LOG_FILE)
    "
fi
