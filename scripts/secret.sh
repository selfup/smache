#!/bin/sh

# generates a strong secret and rpc cookie

echo 'GENERATING SECRET_KEY_BASE AND COOKIE' \
  && echo "
export SECRET_KEY_BASE=$(openssl rand -base64 32)
export COOKIE=$(openssl rand -base64 32)" > .env \
  && echo 'SECRETS JOB DONE'
