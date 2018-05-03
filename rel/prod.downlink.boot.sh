#!/usr/bin/env bash

export APP=smache
export PORT=4000

source ./rel/prod.env \
  && $(elixir rel/vm_args.exs) \
  && ./bin/$APP $1
