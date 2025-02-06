#!/bin/bash

CONFIGS_PATH="./configs"

#region SETUP ENV

setup() {
  PORTAINER_BASE=$1
  for f in $(find -name kind.yaml.template); do
    sed "s#_PORTAINER_PATH_#$PORTAINER_BASE#g" $f >$(dirname $f)/kind.yaml
  done
}

#endregion

#region CLUSTER MANAGEMENT
create() {
  docker-machine create $1
}

delete() {
  docker-machine delete $1
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

#region SWARM

agent() {
  MACHINE=$1
  docker-machine ssh $MACHINE "docker network create --driver overlay --attachable portainer_agent_network"
  if [[ $(echo $?) == 1 ]]; then
    docker-machine ssh $MACHINE "docker service update --force portainer_agent"
  else
    docker-machine ssh $MACHINE """
    docker service create \
      --name portainer_agent --network portainer_agent_network \
      --publish mode=host,target=9001,published=9001 \
      -e AGENT_CLUSTER_ADDR=tasks.portainer_agent \
      --mode global \
      --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
      --mount type=bind,src=//var/lib/docker/volumes,dst=/var/lib/docker/volumes \
      --mount type=bind,src=/,dst=/host \
      portainer/agent
    """
  fi
}

edge() {
  MACHINE=$1
  EDGE_ID=$2
  EDGE_KEY=$3
  docker-machine ssh $MACHINE "docker service update --force portainer_edge_agent"
  if [[ $(echo $?) == 1 ]]; then
    docker-machine ssh $MACHINE """
    docker run -d \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /var/lib/docker/volumes:/var/lib/docker/volumes \
      -v /:/host \
      -v portainer_agent_data:/data \
      --restart always \
      -e EDGE=1 \
      -e EDGE_ID=$($EDGE_ID) \
      -e EDGE_KEY=$($EDGE_KEY) \
      -e CAP_HOST_MANAGEMENT=1 \
      --name portainer_edge_agent \
      portainer/agent
    """
  fi
}

#endregion

usage() {
  echo """
Usage: ./setup.sh ACTION CONTEXT [CONFIG_FILE]

with: - ACTION one of
          setup
          create | delete | recreate | portainer
          deploy | redeploy | remove
          help | usage | *
      - CONTEXT the name of a folder in ./configs/
      - CONFIG_FILE any .yaml config to deploy

ACTIONS:
  - ./setup.sh setup PORTAINER_BASE
    * will create kind files where the base path is set to PORTAINER_BASE

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
create | recreate | portainer | delete | setup)
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
agent)
  if [[ $# == 2 ]]; then
    $1 $2
  fi
  ;;
help | usage | *)
  usage
  ;;
esac
