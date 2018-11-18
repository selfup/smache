#!/usr/bin/env bash

export COMPOSE_CONVERT_WINDOWS_PATHS=1 && docker-compose up $1 $2 $3 $4
