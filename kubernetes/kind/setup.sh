#!/bin/bash

# strict mode - based on http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

CONFIGS_PATH="./configs"
COMMON_CONFIGS_PATH="./common-configs/"

#region SETUP ENV

setup() {
  PORTAINER_BASE=$1
  for f in $(find -name kind.yaml.template); do
    sed "s#_PORTAINER_PATH_#$PORTAINER_BASE#g" $f >"$(dirname $f)"/kind.yaml
  done
}

#endregion

#region CLUSTER MANAGEMENT
create() {
  local CONTEXT=$1
  kind create cluster --config=$CONFIGS_PATH/$CONTEXT/kind.yaml --name $CONTEXT
  reset $CONTEXT
}

delete() {
  kind delete clusters $1
}

recreate() {
  delete $1
  create $1
}

reset() {
  local CONTEXT=$1
  kubectl --context kind-$CONTEXT replace --force -f $COMMON_CONFIGS_PATH/portainer-ns.yaml
  kubectl --context kind-$CONTEXT replace --force -f $COMMON_CONFIGS_PATH/cluster-admin.yaml
  kubectl --context kind-$CONTEXT replace --force -f $COMMON_CONFIGS_PATH/portainer-volume.yaml
}

portainer() {
  kubectl --context kind-$1 replace --force -f $CONFIGS_PATH/$1/portainer.yaml
}

edge() {
  echo $@
  local CONTEXT=$1
  local EDGE_ID=$2
  local EDGE_KEY=$3
  CONTEXT=kind-$CONTEXT ./edge-agent-setup.sh $EDGE_ID $EDGE_KEY
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

#region LIST

# list resources in cluster
list_in_cluster() {
  local CONTEXT=kind-$1
  for i in $(kubectl api-resources | awk '{if (NR>2) {print $1}}'); do
    echo ""
    echo " == $i == "
    kubectl --context $CONTEXT get $i -n portainer
    echo ""
  done
}

# list environments
list_envs() {
  docker ps -a -f name=control-plane --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# alias command for list
ls() {
  list $@
}

# list command
# Command: <list | ls> [env]
# Examples:
# * list -> list environments
# * ls default -> list all resources of env "default"
list() {
  if [[ $# == 1 ]]; then
    list_in_cluster $1
  else
    list_envs
  fi
}

#endregion

usage() {
  echo """
Usage: ./$(basename $0) ACTION CONTEXT [PARAMS]

with: - ACTION one of
          setup
          create | delete | recreate | reset
          deploy | redeploy | remove
          portainer | edge
          kubectl
          list | ls
          help | usage | *
      - CONTEXT the name of a folder in ./configs/
        if not provided uses 'default' (not applicable for 'ls' command)
      - PARAMS any ACTION specific params

ACTIONS:
  - setup PORTAINER_BASE
    * will create kind files where the base path is set to PORTAINER_BASE

  - [ create | delete | recreate | reset ] CONTEXT
    * create: create a new cluster defined by './configs/CONTEXT/kind.yaml'
    * delete: delete cluster defined by './configs/CONTEXT/kind.yaml'
    * recreate: alias for delete + create
    * reset: reset portainer namespace inside CONTEXT cluster (namespace + CA/CRB + portainer volume). Does not redeploy Portainer

  - [ deploy | redeploy | remove ] CONTEXT CONFIG_FILE
    * deploy: deploy the items defined by CONFIG_FILE inside CONTEXT cluster (kubectl apply)
    * redeploy: redeploy the items defined by CONFIG_FILE inside CONTEXT cluster (kubectl replace --force)
    * remove: delete the items defined by CONFIG_FILE inside CONTEXT cluster (kubectl delete --force)

  - portainer CONTEXT
    * redeploy portainer only inside CONTEXT cluster
      using './configs/CONTEXT/portainer.yaml' file (kubectl replace --force)
      Does not (re)create namespace + CA/CRB + volume

  - edge CONTEXT EDGE_ID EDGE_KEY
    * redeploy edge agent inside CONTEXT cluster
      using './configes/edge-agent/edge-agent.yaml' file
      and './edge-agent-setup.sh' script

  - kubectl CONTEXT [<kubectl args>]
    * shortcut for 'kubectl --context kind-CONTEXT <args>'
      no autocomplete provided

  - [ list | ls ] [CONTEXT]
    * with CONTEXT: list the kube objects in the CONTEXT environment
    * without CONTEXT: list created environments

  - [ usage | help | * ]
    display this usage
    """
}

if [[ $# == 0 ]]; then
  usage
  exit
fi

command=$1
shift

context='default'

case $command in
setup | create | recreate | delete | reset | portainer)
  if [[ $# == 1 ]]; then
    context=$1
    shift
  fi
  if [[ $# == 0 ]]; then
    $command $context
  else
    usage
  fi
  ;;
deploy | redeploy | remove)
  if [[ $# == 2 ]]; then
    context=$1
    shift
  fi
  if [[ $# == 1 ]]; then
    $command $context $1
  else
    usage
  fi
  ;;

kubectl)
  $command $@
  ;;
edge)
  if [[ $# == 3 ]]; then
    context=$1
    shift
  fi
  if [[ $# == 2 ]]; then
    $command $context $@
  else
    usage
  fi
  ;;
list | ls)
  if [[ $# -le 1 ]]; then
    $command $@
  else
    usage
  fi
  ;;
help | usage | *)
  usage
  ;;
esac

# sed 's/TAG/1.2.3-20190103/g' x.yaml | kubectl replace -f -
