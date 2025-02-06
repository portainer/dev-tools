#!/bin/bash

# set -x

MANAGER=${1:-3}
WORKER=${2:-0}

for i in $(seq 1 "$MANAGER"); do
  docker rm -f master-"${i}"
done

for i in $(seq 1 "$WORKER"); do
  docker rm -f worker-"${i}"
done
