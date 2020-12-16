#!/bin/bash

CONFIGS_PATH="./configs"

#region CLUSTER MANAGEMENT
create() {
  kind create cluster --config=$CONFIGS_PATH/$1/kind.yaml --name $1
}

portainer() {
  kubectl --context kind-$1 replace --force -f $CONFIGS_PATH/$1/portainer.yaml
}

delete() {
  kind delete clusters $1
}

recreate() {
  delete $1
  create $1
}
#endregion

#region APP MANAGEMENT
deploy() {
  kubectl --context kind-$1 apply -f $2
}

redeploy() {
  kubectl --context kind-$1 replace --force -f $2
}

remove() {
  kubectl --context kind-$1 delete --force -f $2
}
#endregion

usage() {
  echo """
Usage: ./setup.sh ACTION CONTEXT [CONFIG_FILE]

with: - ACTION one of
          create | delete | recreate | portainer
          deploy | redeploy | remove
          help | usage | *
      - CONTEXT the name of a folder in ./configs/
      - CONFIG_FILE any .yaml config to deploy

ACTIONS:
  - ./setup.sh [ create | delete | recreate | portainer ] CONTEXT
    * create: create a new cluster defined by configs/CONTEXT/kind.yaml
    * delete: delete cluster defined by configs/CONTEXT/kind.yaml
    * recreate: alias for delete + create
    * portainer: redeploy portainer inside CONTEXT cluster using configs/CONTEXT/portainer.yaml (kubectl replace --force)

  - ./setup.sh [ deploy | redeploy | remove ] CONTEXT CONFIG_FILE
    * deploy: deploy the items defined by CONFIG_FILE inside CONTEXT cluster (kubectl apply)
    * redeploy: redeploy the items defined by CONFIG_FILE inside CONTEXT cluster (kubectl replace --force)
    * delete: delete the items defined by CONFIG_FILE inside CONTEXT cluster (kubectl delete --force)

  - ./setup.sh [ usage | help | * ]
    show this usage
"""
}

case $1 in
create | recreate | portainer | delete)
  if [[ $# == 2 ]]; then
    $1 $2
  else
    usage
  fi
  ;;
deploy | redeploy | remove)
  if [[ $# == 3 ]]; then
    $1 $2 $3
  else
    usage
  fi
  ;;
help | usage | *)
  usage
  ;;
esac
