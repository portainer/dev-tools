#!/bin/bash

EE_SOURCE_IMAGE="portainerci/portainer-ee:develop"
EE_NEXT_IMAGE="portainer/portainer-ee:2.22.0"

SCRIPT_PATH=`dirname "$0"`

## create docker-machine
docker-machine create swarm

## init swarm
IP=$(docker-machine ls --filter name=swarm -f {{.URL}} | cut -d / -f 3 | cut -d : -f 1)
docker-machine ssh swarm "docker swarm init --advertise-addr ${IP}"

## pull and tag next image
docker-machine ssh swarm "docker pull ${EE_SOURCE_IMAGE} && docker tag ${EE_SOURCE_IMAGE} ${EE_NEXT_IMAGE}"

## upload CE compose file
docker-machine scp "$SCRIPT_PATH/portainer-agent-stack.yml" swarm:~

## create tmp directories
docker-machine ssh swarm "mkdir ~/agent_tmp ~/portainer_tmp"

## start CE
docker-machine ssh swarm "docker stack deploy -c ~/portainer-agent-stack.yml portainer"

## print URL
echo ">> Cluster running at http://${IP}:9000"