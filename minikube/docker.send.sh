#!/usr/bin/env bash

# this script will save your container and send it to minikube vm
# once sent to minikube, docker will load on the kubectl host
# this does not seem to work very well??
# look into using gitlab registry for now
# dockerhub once open sourced

docker save $1 \
  | pv \
  | (eval $(minikube docker-env) && docker load)
