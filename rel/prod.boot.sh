#!/usr/bin/env bash

$(elixir rel/vm_args.exs) && ./bin/$APP foreground
