#!/usr/bin/env bash

VIRTUAL_MITIGATOR=true $(elixir rel/vm_args.exs) && ./bin/$APP foreground
