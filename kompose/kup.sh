#!/usr/bin/env bash

kompose up -f kompose/uplink-deployment.yaml -f kompose/downlink-deployment.yaml \
  && kubectl get deployment,svc,pods
