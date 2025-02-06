#!/bin/bash

# strict mode - based on http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

##
## Automation script of Linkerd setup
## https://linkerd.io/2.11/getting-started
##
## /!\ YOU MUST HAVE A KUBE CLUSTER RUNNING
## AND REACHABLE WITH PURE 'kubectl' CMD (no --context option)
##
## /!\ YOU MUST HAVE LINKERD INSTALLED
## FOLLOW THE ABOVE LINK STEPS 0 AND 1
##

BRACKET="\033[0;34m\U2771\033[0m"
ARROW="\033[0;33m\U1F80A\033[0m"
CROSS="\033[0;31m\U274C\033[0m"
CHECK="\033[0;32m\U2705\033[0m"
WRENCH="\033[0;34m\U1F6E0\033[0m"

PROMPT="  ${BRACKET}${BRACKET}${BRACKET}"

function waitInputToContinue {
  NEXT=${1:-''}
  if [[ ! -z "$NEXT" ]]; then
    echo -e "${PROMPT} Next step ${ARROW} ${NEXT}"
  fi

  read -p "  $(echo -e $BRACKET) Press Enter to continue
"
  if [[ ! -z "$NEXT" ]]; then
    echo -e "  ${WRENCH} ${BRACKET} ${NEXT}
"
  fi
}

function exitOrWaitInputToContinue {
  NEXT=${1:-''}
  if [[ $(echo $?) -ne 0 ]]; then
    echo -e """
${PROMPT} Last step status: ${CROSS} failure"""
    exit 1
  else
    echo -e """
${PROMPT} Last step status: ${CHECK} success"""
  fi
  waitInputToContinue $NEXT
}

## Script sequence start

echo -e """
${PROMPT} Welcome to linkerd install script
${PROMPT} This script is an automation for https://linkerd.io/2.11/getting-started tutorial
"""

waitInputToContinue "Verify kubectl can reach host"
kubectl config view

exitOrWaitInputToContinue "Verify linkerd version"
linkerd version

exitOrWaitInputToContinue "Verify cluster requirements"
linkerd check --pre

exitOrWaitInputToContinue "Install linkerd control plane onto the cluster"
linkerd install | kubectl apply -f -

exitOrWaitInputToContinue "Verify linkerd install"
linkerd check

exitOrWaitInputToContinue "Install linkerd viz extension"
linkerd viz install | kubectl apply -f -

exitOrWaitInputToContinue "Verify viz extensions install"
linkerd check

exitOrWaitInputToContinue "Open viz dashboard"
linkerd viz dashboard &
sleep 5

exitOrWaitInputToContinue "Install demo app"
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -

exitOrWaitInputToContinue "Mesh demo app"
kubectl get -n emojivoto deploy -o yaml |
  linkerd inject - |
  kubectl apply -f -

exitOrWaitInputToContinue "Verify mesh configuration (run data plane checks)"
linkerd -n emojivoto check --proxy

exitOrWaitInputToContinue "Proxy demo app to http://localhost:8080"
echo -e "$PROMPT Waiting for service to be running"
until [[ $(kubectl -n emojivoto get endpoints/web-svc -o=jsonpath='{.subsets[*].addresses[*].ip}') ]]; do sleep 5; done
kubectl -n emojivoto port-forward svc/web-svc 8080:80 &
sleep 5

echo "
If you encounter an error like 'an error occurred forwarding 8080 -> 8080: error forwarding port 8080 to pod XXX'
Run the following command to restart the proxy
kubectl -n emojivoto port-forward svc/web-svc 8080:80
"

exitOrWaitInputToContinue "Explore the app"
echo "Browse http://localhost:8080"
echo "An app should be running here"
echo "You should encounter a 404 error when voting for the donut emoji"
echo "That's an expected 404 to generate errors in stats"

exitOrWaitInputToContinue "Deploy portainer in cluster"
## this is the command to deploy a full portainer setup in an empty env
## Don't use with dev-tools envs!
kubectl apply -n portainer -f https://downloads.portainer.io/ee2-13/portainer.yaml
## this is the command to deploy it in dev-tools default machine
# ./setup.sh portainer

exitOrWaitInputToContinue "Mesh portainer"
kubectl get -n portainer deploy -o yaml |
  linkerd inject - |
  kubectl apply -f -

exitOrWaitInputToContinue "Verify mesh configuration (run data plane checks)"
linkerd -n portainer check --proxy

exitOrWaitInputToContinue "Proxy Portainer to http://localhost:9000"
echo -e "$PROMPT Waiting for service to be running"
until [[ $(kubectl -n portainer get endpoints/portainer -o=jsonpath='{.subsets[*].addresses[*].ip}') ]]; do sleep 5; done
kubectl -n portainer port-forward svc/portainer 9000:9000 &
sleep 5
echo "
Portainer should be reachable at http://localhost:9000
Please configure admin account before it turns off !

If you encounter errors like ' an error occurred forwarding 9000 -> 9000: error forwarding port 9000 to pod XXX'
Run the following command to restart the proxy
kubectl -n portainer port-forward svc/portainer 9000:9000
"

waitInputToContinue
echo -e "
${PROMPT} Well done.

${PROMPT} If you arrived to this point Portainer is in the mesh along with the demo app
${PROMPT} You can browse the viz dashboard at http://localhost:50750 to explore your mesh.

${PROMPT} [END OF SCRIPT]
"
