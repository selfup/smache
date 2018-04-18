#!/usr/bin/env bash

echo 'GENERATING SECRET_KEY_BASE AND COOKIE' \
  && elixir ./scripts/secret_gen.exs \
  && echo 'SECRETS JOB DONE'
