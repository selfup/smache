#!/usr/bin/env bash

./scripts/secret.sh \
    && echo 'registry REGISTRY CONTAINER WILL BUILD AND RUN' \
    && docker-compose -f docker-compose.registry.yml up --build
