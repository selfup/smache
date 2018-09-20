#!/usr/bin/env bash

# orchestrate 1 nginx reverse proxy and a cluster of 4 smache nodes
# 1 uplink to guarantee downlinks can attach
# 3 downlinks to prove distributed mesh network can be created

# --build can be passed as $1 to rebuild containers
# ex: ./scripts/services.sh --build

./scripts/secret.sh \
  && docker-compose up --scale downlink=3 $1
