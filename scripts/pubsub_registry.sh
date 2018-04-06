#!/usr/bin/env bash

./scripts/secret.sh \
    && echo 'PUBSUB REGISTRY CONTAINER WILL BUILD AND RUN' \
    && docker-compose -f docker-compose.pubsub_registry.yml up --build
