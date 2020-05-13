#!/usr/bin/env bash

set -e

if [[ -f .env ]]
then
  source .env
fi

NAME_FROM_SNAME=$(nslookup uplink | grep 'Address: ' | head -2 | tail -1 | tr -d 'Address: ' | tr -d '\n')

NAME=smache@$NAME_FROM_SNAME COOKIE=$COOKIE REPLACE_OS_VARS=true _build/prod/rel/smache/bin/smache start
