#!/usr/bin/env bash

# copies erl release tarball from release container
# then stops that container

docker cp $(docker ps --latest --quiet):/smache.tar.gz ./smache.tar.gz \
  && echo 'RELEASE COPIED' \
  && docker stop $(docker ps --latest --quiet)
