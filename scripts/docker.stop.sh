#!/usr/bin/env bash

PS_AQ=$(docker ps -aq)

if [ !$PS_AQ ]
then
  echo 'NOTHING TO STOP'
else
  echo ' STOPPING ALL CONTAINERS' \
    && docker stop $PS_AQ \
fi
