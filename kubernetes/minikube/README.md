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
