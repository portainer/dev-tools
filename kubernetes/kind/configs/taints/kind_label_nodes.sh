#!/bin/bash

# DONT FORGET TO CHANGE THE CONTEXT TO THE KIND CLUSTER NAME YOU WANT TO TAINT
CONTEXT="kind-taints"

# replace =<value> by - to unlabel (... kind-worker foo- )
kubectl --context $CONTEXT label nodes taints-worker foo=bar
kubectl --context $CONTEXT label nodes taints-worker2 hello=world
