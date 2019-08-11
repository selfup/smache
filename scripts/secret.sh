#!/usr/bin/env bash

# generates a strong secret and rpc cookie

function genSec32() {
  openssl rand -base64 32
}

function genSec64() {
  openssl rand -base64 64
}

function genEnv() {
  echo "
export SECRET_KEY_BASE=$genSec64
export COOKIE=$genSec32
  "
}

echo 'GENERATING SECRET_KEY_BASE AND COOKIE' \
  && genEnv \
  && echo 'SECRETS JOB DONE'
