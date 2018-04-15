#!/usr/bin/env bash

$(elixir rel/vm_args.exs)
echo $COOKIE
echo $SNAME_IP
_build/prod/rel/smache/bin/smache foreground
