#!/bin/bash

# set -x

LATEST="stable"

MANAGER=${1:-3}
WORKER=${2:-0}
VERSION=${3:-$LATEST}

DIND_TAG="${VERSION}-dind"

#=========================
# Creating cluster members
#=========================
echo "### Creating $MANAGER managers"
for i in $(seq 1 "$MANAGER"); do
  if [[ $i -eq 1 ]]; then
  docker run -d --privileged --name master-"${i}" --hostname=master-"${i}" -p 9000:9000 -p 9443:9443 -p 8000:8000 docker:"${DIND_TAG}"
  else
  docker run -d --privileged --name master-"${i}" --hostname=master-"${i}" docker:"${DIND_TAG}"
  fi
done

echo "### Creating $WORKER workers"
for i in $(seq 1 "$WORKER"); do
  docker run -d --privileged --name worker-"${i}" --hostname=worker-"${i}" docker:"${DIND_TAG}"
done

sleep 5

#===============
# Starting swarm
#===============
echo "### Initializing main master"
docker exec master-1 docker swarm init
MANAGER_IP=$(docker exec master-1 ip addr | grep 172 | grep eth0 | cut -d ' ' -f 6 | cut -d '/' -f 1)

# MANAGER_IP="172.17.0.1"
# docker --host=localhost:12375 swarm init --advertise-addr "$MANAGER_IP"

sleep 5

#===============
# Adding members
#===============
MANAGER_TOKEN=$(docker exec master-1 docker swarm join-token -q manager)
WORKER_TOKEN=$(docker exec master-1 docker swarm join-token -q worker)

for i in $(seq 2 "$MANAGER"); do
  echo "### Joining manager-$i"
  docker exec master-"${i}" docker swarm join --token "${MANAGER_TOKEN}" "${MANAGER_IP}":2377
  # docker --host=localhost:"${i}"2376 swarm join --token "${MANAGER_TOKEN}" "${MANAGER_IP}":2377
done
for i in $(seq 1 "$WORKER"); do
  echo "### Joining worker-$i"
  docker exec worker-"${i}" docker swarm join --token "${WORKER_TOKEN}" "${MANAGER_IP}":2377
  # docker --host=localhost:"${i}"3376 swarm join --token "${WORKER_TOKEN}" "${MANAGER_IP}":2377
done

docker exec master-1 docker node ls
