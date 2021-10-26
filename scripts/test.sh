#!/usr/bin/env bash

export TEST=1 && echo 'GRABBING AND COMPILING DEPENDENCIES' \
  && mix deps.get \
  && mix deps.compile \
  && echo 'TESTING SMACHE APP' \
  && mix test \
  && echo 'ALL TESTS PASS' \
  && unset TEST \
  && echo $TEST
