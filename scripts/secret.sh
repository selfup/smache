#!/usr/bin/env bash

# generates a strong secret and rpc cookie

echo 'GENERATING SECRET_KEY_BASE AND COOKIE' \
  && elixir ./scripts/secret_gen.exs \
  && echo 'SECRETS JOB DONE'
