#!/usr/bin/env bash

# pass in the PORT for dev as $1
# pass in the sname for dev as $2
# pass in the host for UPLINK_NODE as $3

# ex: ./scripts/dev.sh 4000 smache@localhost localhost
# ex2: ./scripts/dev.sh 4000 smache2@localhost localhost

PORT=$1 UPLINK_NODE=$3 iex --sname $2 --cookie wow -S mix phx.server
