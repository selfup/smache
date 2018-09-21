#!/usr/bin/env bash

./minikube/docker.send.sh smache_uplink \
  && ./minikube/docker.send.sh smache_downlink \
  && kompose up -f kompose/uplink-deployment.yaml -f kompose/downlink-deployment.yaml \
  && kubectl get deployment,svc,pods
