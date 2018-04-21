#!/usr/bin/env bash

echo "
  $(curl --fail --silent --show-error "localhost:$1/api/?key=1")
  $(curl --fail --silent --show-error "localhost:$1/api/?key=2")
"
