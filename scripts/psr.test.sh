#!/usr/bin/env bash

./scripts/secret.sh

cd registry \
    && echo 'GRABBING AND COMPILING DEPENDENCIES' \
    && mix deps.get \
    && mix deps.compile \
    && echo 'TESTING APP' \
    && mix test \
    && echo 'CONTAINER WILL RUN AFTER BEING BUILT' \
    && cd .. \
    && docker-compose build \
