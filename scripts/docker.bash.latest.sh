#!/usr/bin/env bash

docker exec -it $(docker ps --latest --quiet) /bin/bash
