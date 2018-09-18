#!/usr/bin/env bash

$(elixir rel/vm_args.exs) \
  && bin/smache foreground
