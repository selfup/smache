#!/usr/bin/env bash

source ./rel/uplink.env \
  && $(elixir rel/vm_args.exs) \
  && ./bin/$APP $1
