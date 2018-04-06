#!/usr/bin/env bash

./scripts/secret.sh \
    && echo 'SMACHE CONTAINER WILL BUILD AND RUN' \
    && docker-compose -f docker-compose.smache.yml up --build
