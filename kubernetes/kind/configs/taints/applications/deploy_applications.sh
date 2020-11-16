#!/bin/bash

CONTEXT="kind-taints"

# node affinities > untaint worker to deploy on worker (no need to redeploy after untainting node)
kubectl --context $CONTEXT replace --force -f ./affinities/nginx-na.yaml

# nodeSelector > untaint worker2 to deploy on worker2 (no need to redeploy after untainting node)
kubectl --context $CONTEXT replace --force -f ./affinities/nginx-ns.yaml

# toleration + node affinities > should deploy on worker
kubectl --context $CONTEXT replace --force -f ./both/nginx-na.yaml

# toleration + nodeSelector > should deploy on worker2
kubectl --context $CONTEXT replace --force -f ./both/nginx-ns.yaml

# toleration > should deploy on worker
kubectl --context $CONTEXT replace --force -f ./tolerations/nginx.yaml

# toleration2 > should deploy on worker2
kubectl --context $CONTEXT replace --force -f ./tolerations/nginx-2.yaml
