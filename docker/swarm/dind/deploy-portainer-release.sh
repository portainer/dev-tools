#!/bin/bash

# set -x

VERSION=${1:-"ce2-20"}

docker exec master-1 wget https://downloads.portainer.io/"${VERSION}"/portainer-agent-stack.yml -O portainer-agent-stack.yml && docker exec master-1 docker stack deploy -d -c portainer-agent-stack.yml portainer