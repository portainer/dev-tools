To support ingress your `kind.yaml` file should contain the section `kubeadmConfigPatches` for your `control-plane` node

```yaml
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
```

Once kind env is created, deploy nginx ingress controller using
`kubectl --context kind-<YOUR_ENV> apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml`

Deploy a test application using `kubectl --context kind-<YOUR_ENV> apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml`

See https://kind.sigs.k8s.io/docs/user/ingress for more examples/info
