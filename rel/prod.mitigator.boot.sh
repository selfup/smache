#!/usr/bin/env bash

export UPLINK=true
export VIRTUAL_MITIGATOR=true
export APP=smache
export PORT=4000

$(elixir rel/vm_args.exs) \
  && ./bin/$APP console
