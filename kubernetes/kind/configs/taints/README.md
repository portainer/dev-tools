This context is a env to test tolerations and affinities (1 master + 2 workers)
Some example applications can be found under the `applications` folder.
This context also contains scripts to apply taints and labels on cluster nodes and a script to deploy applications inside this cluster.

1. Deploy it like any context using `setup.sh`
2. Apply taints and labels with `kind_taint_nodes.sh` and `kind_label_nodes.sh`
3. Deploy applications with `applications/deploy_applications.sh`