#!/bin/bash

# DONT FORGET TO CHANGE THE CONTEXT TO THE KIND CLUSTER NAME YOU WANT TO TAINT
CONTEXT="kind-taints"

# add - at the end to untaint (... kind-worker foo=bar:NoExecute- )
kubectl --context $CONTEXT taint nodes taints-worker foo=bar:NoExecute
kubectl --context $CONTEXT taint nodes taints-worker2 hello-world:NoExecute
