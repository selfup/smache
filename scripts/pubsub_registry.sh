#!/usr/bin/env bash

./scripts/secret.sh \
    && echo 'CONTAINER WILL BUILD' \
    && docker-compose -f docker-compose.pubsub_registry.yml up --build
