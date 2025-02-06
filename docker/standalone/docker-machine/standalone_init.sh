#!/bin/bash

EE_SOURCE_IMAGE="portainerci/portainer-ee:develop"
EE_NEXT_IMAGE="portainer/portainer-ee:2.22.0"
CE_IMAGE="portainerci/portainer-ce:pr11728"

SCRIPT_PATH=`dirname "$0"`
MACHINE="standalone"

## create docker-machine
docker-machine create "$MACHINE"

## get ip
IP=$(docker-machine ls --filter name="$MACHINE" -f {{.URL}} | cut -d / -f 3 | cut -d : -f 1)

## pull and tag next image
docker-machine ssh "$MACHINE" "docker pull ${EE_SOURCE_IMAGE} && docker tag ${EE_SOURCE_IMAGE} ${EE_NEXT_IMAGE}"


## create tmp directories
docker-machine ssh "$MACHINE" "mkdir ~/portainer_tmp"

## start CE
docker-machine ssh "$MACHINE" docker run -d \
  -p 8000:8000 -p 9443:9443 -p 9000:9000 \
  --name portainer --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  -v ~/portainer_tmp:/tmp \
  -e UPGRADE_SKIP_PULL_PORTAINER_IMAGE=true \
  "$CE_IMAGE" --log-level=DEBUG

## print URL
echo ">> Cluster running at http://${IP}:9000"