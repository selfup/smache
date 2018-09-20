#!/usr/bin/env bash

source ./rel/prod.env \
  && $(elixir rel/vm_args.exs) \
  && ./bin/$APP $1
