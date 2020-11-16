#!/bin/bash

CONTEXT="minikube"

# update the dev path to match yours
DEV_PATH="/home/baron_l/projects/pro/portainer/dist"
# KUBERNETES_VERSION="v1.18.3"
KUBERNETES_VERSION="latest"
DRIVER="docker"

ip() {
  echo "Cluster running on" `minikube ip`
}

create() {
  minikube start --driver=$DRIVER --mount --mount-string $DEV_PATH:/portainer/app --kubernetes-version=$KUBERNETES_VERSION
  ip
}

deploy() {
  kubectl --context $CONTEXT replace --force -f ./$1.yaml
}

remove() {
  kubectl --context $CONTEXT delete -f ./$1.yaml
}

delete() {
  minikube delete
}

redeploy() {
  deploy $1
}

recreate() {
  delete
  create
}

usage() {
  echo """
  Usage: ./setup.sh ACTION [CONFIG (--force)]

  with: ACTION in [create|recreate|deploy|redeploy|delete|remove|ip]
          - create, recreate, delete, ip require no parameters
          - deploy, redeploy, remove require CONFIG parameter
        CONFIG the name of a file next to ./setup.sh (without extension)

  Examples:
  - create cluster and deploy portainer.yaml inside it: ./setup.sh create && ./setup.sh deploy portainer
  - redeploy portainer-agent.yaml inside cluster: ./setup.sh redeploy portainer-agent
  - remove portainer-agent-edge.yaml of cluster: ./setup.sh remove portainer-agent-edge
  """
}

case $1 in
deploy | redeploy | remove)
  if [[ $# == 2 ]]; then
    $1 $2
  else
    usage
  fi
  ;;
create | recreate | delete | ip)
  $1
  ;;
help | usage | *)
  usage
  ;;
esac
