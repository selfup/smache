#!/usr/bin/env bash

# --build can be passed as $1 to rebuild containers
# ex: ./scripts/services.sh --build

if [ "$TWO" == "" ]
then
  echo 'DEFAULTING SECOND DOCKER HOST IP NUMBER TO: 20'
  echo 'PLEASE CHECK OUTPUT ON FIRST RUN TO SEE ACTUAL IPS OF NODES'
  TWO=20
fi

./scripts/secret.sh && UPLINK_NODE=uplink@172.$TWO.0.2 docker-compose up $1
