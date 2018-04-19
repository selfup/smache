#!/usr/bin/env bash

# pass in the PORT for dev as $1
# pass in the sname for dev as 2!
# ex: ./scripts/dev/sh 4000 foo

mkdir -p smache_mnt/sync_dir \
  && rm -rf /mnt/sync_dir/* \
  && PORT=$1 iex --sname $2 --cookie wow -S mix phx.server
