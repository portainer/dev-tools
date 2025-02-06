#!/bin/bash

### PREREQUISITES
# docker
# kind

PORTAINER_FOLDER="./qa"
LB_FOLDER="./lb"
KIND_NAME="qa"
KIND_CONTEXT=kind-$KIND_NAME

#region SETUP METALLB
# metallb() {
#   kubectl apply -f $LB_FOLDER/namespace.yaml
#   kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
#   kubectl apply -f $LB_FOLDER/metallb.yaml
# }
#endregion

#region 
generate_portainer_yaml() {
  PORTAINER_TAG=$1
  sed "s#%PORTAINER_TAG%#$PORTAINER_TAG#g" $PORTAINER_FOLDER/portainer.yaml.template > $PORTAINER_FOLDER/portainer.$PORTAINER_TAG.yaml;
}
#endregion

#region CLUSTER MANAGEMENT
create() {
  kind create cluster --config=$PORTAINER_FOLDER/kind.yaml --name $KIND_NAME
}

portainer() {
  PORTAINER_TAG=$1

  IFS=: read -r USERNAME PASSWORD < .creds
  kubectl --context $KIND_CONTEXT replace --force -f $PORTAINER_FOLDER/portainer.$PORTAINER_TAG.yaml
}

delete() {
  kind delete clusters $KIND_CONTEXT
}

recreate() {
  delete
  create
}
#endregion

#region APP MANAGEMENT
deploy() {
  FILE=$1
  kubectl --context $KIND_CONTEXT apply -f $FILE
}

redeploy() {
  FILE=$1
  kubectl --context $KIND_CONTEXT replace --force -f $FILE
}

remove() {
  FILE=$1
  kubectl --context $KIND_CONTEXT delete --force -f $FILE
}
#endregion

setup_and_run() {
  PR_ID=pr$1
  # recreate cluster
  recreate
  # generate portainer file
  generate_portainer_yaml $PR_ID
  # create secret for portainerci/EE pulls
  # deploy portainer file
}


usage() {
  echo """
Usage: ./setup.sh ENV [<PORTAINER_CI_DOCKER_TAG> | usage | help]
  
  - ENV one of [ CE | ce | EE | ee ]
  - PORTAINER_CI_DOCKER_TAG must be a portainerci/portainer-<ENV> tag (e.g pr1234 or develop)
  
  This config is using ports 9000, 8000 and 30778 of the machine, make sure no containers or VMs are already bound to them.
  You can only have one PR running at a time. Deploying a new PR will destroy the previous one and rebuild the entire env from scratch.
"""
}

case $1 in
help | usage | '')
  usage
  ;;
*)
  if [[ $# == 2 ]]; then
    setup_and_run $2
  ;;
esac
