#!/usr/bin/env bash

./scripts/secret.sh \
    && make \
    && echo 'MITIGATOR CONTAINER WILL BUILD AND RUN' \
    && docker-compose -f docker-compose.mitigator.yml up --build
