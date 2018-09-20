#!/usr/bin/env bash

$(elixir rel/vm_args.exs) \
  && _build/prod/rel/smache/bin/smache foreground
