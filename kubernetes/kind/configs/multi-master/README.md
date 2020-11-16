The goal of this environment is to demonstrate how to deploy portainer inside a multi master nodes cluster.

1. Deploy it like any context using `setup.sh`
2. Run `./kind_taint_and_labels_nodes.sh` script to limit Portainer to a single instance inside the cluster.
