#!/usr/bin/env bash

kompose up -f kompose/uplink-deployment.yaml \
  && kubectl get deployment,svc,pods
