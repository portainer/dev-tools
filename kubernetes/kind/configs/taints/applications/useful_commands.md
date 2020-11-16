### Get nodes taints

`kubectl describe nodes | grep -E 'Taints:|Name:'`

Variant if you have multiple taints per node
`kubectl describe nodes | grep -E 'Taints:|Name:|*'`

### Get node labels

`kubectl get nodes --show-labels` or `kubectl describe nodes | grep -E 'Labels:|*'`