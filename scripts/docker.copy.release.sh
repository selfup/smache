#!/usr/bin/env bash

docker cp $(docker ps --latest --quiet):/smache.tar.gz ./smache.tar.gz \
    && echo 'RELEASE COPIED' \
    && docker stop $(docker ps --latest --quiet)
