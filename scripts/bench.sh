#!/usr/bin/env bash

# requires ab (apache bench)
# comes pre-installed on macOS
# to install on linux visit: https://www.ndchost.com/wiki/apache/stress-testing-with-apache-benchmark
# unfortunately not available on windows :(

SMACHE_LOG_FILE=.results.smache.log

if [ "$HOST" == "" ]
then
  echo "
    NO HOST PROVIDED
    DEFAULTING TO ::: localhost
  "
  HOST=localhost
fi

ab \
  -n 50000 \
  -c 900 \
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
  -n 50000 \
  -c 900 \
  -k -v 1 \
  -H "Accept-Encoding: gzip, deflate" \
  -T "application/json" \
  http://$HOST:$1/api/?key=1 > $SMACHE_LOG_FILE \
  && echo "" \
  && echo "--> results:

    $(grep seconds $SMACHE_LOG_FILE)
    $(grep -w second $SMACHE_LOG_FILE)
    $(grep -w '50%' $SMACHE_LOG_FILE) ms
    $(grep -w '95%' $SMACHE_LOG_FILE) ms
    $(grep -w longest $SMACHE_LOG_FILE)
  "
