# Microk8s in Vagrant

1. Install vagrant and virtualbox
2. Run `./install.sh`

The script will:
* create an vagrant box (ubuntu)
* update & update ubuntu
* install microk8s
* enable required addons for portainer
* start Portainer on microk8s using the portainer addon

## Notes

* Default assigned IP is: `192.168.99.254`
* Restart Portainer inside Vagrant box (in case of admin init timeout): `./restart_portainer.sh`
* Fully reset Portainer inside Vagrant box: see head comment of script `redeploy_portainer.sh` for usage

### Upload a local image to remote microk8s
* save image `docker save image -o image.tar`
* import image `microk8s ctr images import /vagrant/image.tar`

### Deploy custom updater to vagrant box

⚠️ Do not use `latest` tag or kubernetes will try to pull the image from remote and not use the local image

⚠️ This is caused by our server code not specifying an `imagePullPolicy`, which defaults to `Always` when `latest` tag is used

```sh
git clone git@github.com:portainer/portainer-updater.git
cd portainer-updater
make image
docker image tag portainerci/portainer-updater:latest localupdater:custom
docker image save localupdater:custom -o updater.tar
# cp updater.tar to vagrant bound folder (where this README is located)
# cd to vagrant bound folder
vagrant ssh -c "microk8s ctr image import /vagrant/updater.tar"
vagrant ssh -c "microk8s kubectl set env -n portainer deployment/portainer UPGRADE_UPDATER_IMAGE=localupdater:custom"
```
The last command will recreate the pod with the new env var.

Once restarted, login in UI and init the upgrade to EE.