#!/usr/bin/env bash

# --build can be passed as $1 to rebuild containers
# ex: ./scripts/smache.sh --build

./scripts/secret.sh \
  && echo 'CONTAINER WILL BUILD' \
  && docker-compose -f docker-compose.smache.yml up $1
