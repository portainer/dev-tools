# Development

This folder includes usefull scripts and preconfigured environments to test some Portainer features inside specific contexts.

## Minikube

### Requirements

- [minikube](https://minikube.sigs.k8s.io/)

### Usage

1. Start Portainer in development mode via `yarn start`
2. Go to minikube folder `cd ./minikube`
3. Update the `DEV_PATH` variable of `setup.sh` script to your dev `dist` directory
4. Create/start minikube cluster: `./setup.sh create`
4. (alternative): `minikube start --mount --mount-string /path/to/dev/dist/directory:/portainer/app`
4. (alternative for specific Kubernetes version): `minikube start --driver=docker --mount --mount-string /path/to/dev/dist/directoy:/portainer/app --kubernetes-version=v1.18.3`
5. Deploy or force an update of an existing Portainer app: `./setup.sh redeploy portainer`
5. (alternative): `kubectl replace --force -f portainer.yaml`
6. Retrieve minikube IP: `./setup.sh ip` or `minikube ip`

Open browser at `<minikube_IP>:9000`

##### Notes

* Using `setup.sh` script automatically creates a minikube instance with `--driver=docker` and `latest` version of kubernetes
* You can change the kubernetes version inside `setup.sh`
* `./setup.sh create` gives you the IP of the created Minikube instance (like `minikube ip`)
* You can deploy any application inside minikube instance with `setup.sh` script ; for example `./setup.sh deploy applications/minio` or `./setup.sh deploy applications/autoscaler/autoscaler-dep`
* `minikube/applications` contains subfolders with manifests and scripts to automatically deploy specific contexts (autoscaler, ingresses with nginx or traefik)


## kind

### Requirements

- [kind](https://kind.sigs.k8s.io/)

### Usage

1. Update the `hostPath` property in all `configs/**/kind.yaml` files to match the path of the project on your filesystem
1. (optional) Update the `hostPort` property in all `configs/**/kind.yaml` files to the port that suits you the best to access portainer instance. Default ports are, by context:
  * base: 9010
  * ingress: 9020
  * multi-master: 9030
  * taints: 9040
2. Create the cluster with `./setup.sh create <ENV>` where `<ENV>` is the name of the subfolder inside `configs` folder
3. Start Portainer in development mode via `yarn start`
4. Deploy or force an update of any existing Portainer app: `./setup.sh deploy <ENV>`

Open browser at `localhost:<hostPort>` (`hostPort` is defined in `kind.yaml` file, default values listed above)

##### Notes
* Multiple clusters can run at the same time, updating portainer frontend will update all running clusters (for backend you need to use step 4 to redeploy on every cluster you want)
* `setup.sh` script provides some commands to help you recreate / redeploy / delete clusters. See them with `./setup help` or `./setup.sh usage`
* kubernetes context for all the provided configs is `kind-<CONTEXT>` (e.g. `kind-base` for `base` folder, `kind-ingress` for `ingress` folder, etc)
* You can deploy applications located inside the `applications` folder inside any kind environment with `kubectl --context kind-<CONTEXT> replace --force -f applications/<APP.YAML>` where `<CONTEXT>` is the application context (see above) and `<APP.YAML>` is your application yaml file inside `applications` folder
* You don't need to recreate the cluster everytime you boot ; clusters are respawned on machine boot. You may want to redeploy Portainer everytime you do a fresh build to clear all previous deployment data. 