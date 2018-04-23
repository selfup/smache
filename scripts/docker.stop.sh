#!/usr/bin/env bash

# PLEASE READ THIS
# ****************
# STOPS ALL DOCKER CONTAINERS ON YOUR ENTIRE MACHINE
# ****************
# PLEASE READ THIS

PS_AQ=$(docker ps -aq)

if [ !"$PS_AQ" ]
then
  echo 'NOTHING TO STOP'
else
  echo ' STOPPING ALL CONTAINERS' \
    && docker stop $PS_AQ
fi
