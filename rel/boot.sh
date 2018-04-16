#!/usr/bin/env bash

$(elixir rel/vm_args.exs) \
  && _build/prod/rel/$APP/bin/$APP foreground
