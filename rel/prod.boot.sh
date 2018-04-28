#!/usr/bin/env bash

export APP=smache
export PORT=4000
$(elixir rel/vm_args.exs) \
  && ./bin/$APP console
