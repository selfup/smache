#!/usr/bin/env bash

rm -rf /tmp/sync_dir/*
PORT=$1 iex --sname $2 --cookie wowwowow -S mix phx.server
