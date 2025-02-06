#!/bin/bash

function usage() {
  cat <<EOF
    Usage: portainer_ci PORTAINER_CI_IMAGE [port 9000 binding] [port 9443 binding] [port 8000 binding]

    Example:
        portainer_ci portainerci/portainer-ee:develop
            will start 'portainerci/portainer-ee:develop running at localhost:9000 / localhost:9443'
EOF
}

VM="test-automation"

function create() {
  docker-machine rm -f ${VM}
  sleep 5
  docker-machine create ${VM}
}

function portainer_ci() {
  local PORTAINER_CI_IMAGE=$1
  local P9000=${2:-9000}
  local P9443=${3:-9443}
  local P8000=${4:-8000}
  docker-machine ssh ${VM} "docker pull ${PORTAINER_CI_IMAGE}"
  docker-machine ssh ${VM} "docker run -d -p ${P9000}:9000 -p ${P9443}:9443 -p ${P8000}:8000 --name portainerci_${P9000} -v /var/run/docker.sock:/var/run/docker.sock -v portainerci_${P9000}_data:/data ${PORTAINER_CI_IMAGE} --log-level=DEBUG"
  local IP=$(docker-machine ls --filter name=${VM} -f "{{.URL}}")
  local IP_9000=$(echo ${IP} | awk -v port=${P9000} '{sub(/tcp/,"http")sub(/:[0-9].*/,":"port)}1')
  local IP_9443=$(echo ${IP} | awk -v port=${P9443} '{sub(/tcp/,"https")sub(/:[0-9].*/,":"port)}1')
  echo "Container running at ${IP_9000} | ${IP_9443}"
}

function portainer_ci_clean() {
  P9000=${1:-9000}
  echo "Cleaning portainerci container"
  docker-machine ssh ${VM} "docker rm -f portainerci_${P9000}"
  echo "cleaning portainerci volume"
  docker-machine ssh ${VM} "docker volume rm portainerci_${P9000}_data"
  echo "Done"
}

case $1 in
create)
  create
  ;;
deploy)
  if [[ $# == 2 ]]; then
    portainer_ci $2
  else
    usage
  fi
  ;;
clean)
  portainer_ci_clean
  ;;
*)
  usage
  ;;
esac
