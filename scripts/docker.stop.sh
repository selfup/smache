#!/usr/bin/env bash

# PLEASE READ THIS
# ****************
# STOPS ALL DOCKER CONTAINERS ON UPLINKUR ENTIRE MACHINE
# ****************
# PLEASE READ THIS

PS_AQ=$(docker ps -aq)

echo ' STOPPING ALL CONTAINERS' \
  && docker stop $PS_AQ
