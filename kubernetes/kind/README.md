### Requirements

- [kind](https://kind.sigs.k8s.io/)

### Usage

1. Update the `hostPath` property in all `configs/**/kind.yaml` files to match the path of the project on your filesystem
1. (optional) Update the `hostPort` property in all `configs/**/kind.yaml` files to the port that suits you the best to access portainer instance. Default ports are, by context:
  * base: 9010
  * ingress: 9020
  * multi-master: 9030
  * taints: 9040
  * agent: 9050
2. Create the cluster with `./setup.sh create <ENV>` where `<ENV>` is the name of the subfolder inside `configs` folder
3. Start Portainer in development mode via `yarn start`
4. Deploy or force an update of any existing Portainer app: `./setup.sh portainer <ENV>`

Open browser at `localhost:<hostPort>` (`hostPort` is defined in `kind.yaml` file, default values listed above)

##### Notes
* Multiple clusters can run at the same time, updating portainer frontend will update all running clusters (for backend you need to use step 4 to redeploy on every cluster you want)
* `setup.sh` script provides some commands to help you recreate / redeploy / delete clusters. See them with `./setup help` or `./setup.sh usage`
* kubernetes context for all the provided configs is `kind-<CONTEXT>` (e.g. `kind-base` for `base` folder, `kind-ingress` for `ingress` folder, etc)
* You can deploy applications located inside the `applications` folder inside any kind environment with `./setup.sh deploy <CONTEXT> applications/<APP.YAML>` where `<CONTEXT>` is the application context (see above) and `<APP.YAML>` is your application yaml file inside `applications` folder
* You don't need to recreate the cluster everytime you boot ; clusters are respawned on machine boot. You may want to redeploy Portainer everytime you do a fresh build to clear all previous deployment data.