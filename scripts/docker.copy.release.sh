#!/usr/bin/env bash

# copies erl release tarball from release container

docker cp $(docker ps --latest --quiet):/smache_release smache_rel \
  && echo 'RELEASE COPIED'
