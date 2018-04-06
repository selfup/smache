#!/usr/bin/env bash

./scripts/secret.sh

cd smache \
    && echo 'GRABBING AND COMPILING DEPENDENCIES' \
    && mix deps.get \
    && mix deps.compile \
    && echo 'TESTING SMACHE APP' \
    && mix test \
    && cd ../pubsub_registry \
    && echo 'GRABBING AND COMPILING DEPENDENCIES' \
    && mix deps.get \
    && mix deps.compile \
    && echo 'TESTING SMACHE APP' \
    && mix test \
    && cd .. \
    && echo 'ALL TESTS PASS'
