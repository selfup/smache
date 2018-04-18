#!/usr/bin/env bash

# --build can be passed as $1 to rebuild containers
# ex: ./scripts/services.sh --build

./scripts/secret.sh && docker-compose up $1
