#!/bin/bash

# DONT FORGET TO CHANGE THE CONTEXT TO THE KIND CLUSTER NAME YOU WANT TO TAINT
CONTEXT="kind-multi-master"

kubectl --context $CONTEXT taint nodes multi-master-control-plane portainer=accept:NoExecute
kubectl --context $CONTEXT taint nodes multi-master-control-plane2 multi-master-control-plane3 portainer=reject:NoSchedule

# add - at the end of the command to untaint (... multi-master-control-plane foo=bar:NoExecute- )
# untaint commands for the 2 taintss above
# kubectl --context $CONTEXT taint nodes multi-master-control-plane portainer=accept:NoExecute-
# kubectl --context $CONTEXT taint nodes multi-master-control-plane2 multi-master-control-plane3 portainer=reject:NoSchedule