#!/usr/bin/env bash

./scripts/secret.sh \
  && echo 'GRABBING AND COMPILING DEPENDENCIES' \
  && mix deps.get \
  && mix deps.compile \
  && echo 'TESTING SMACHE APP' \
  && mix test \
  && echo 'ALL TESTS PASS'
