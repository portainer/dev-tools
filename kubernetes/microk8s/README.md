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

Default assigned IP is: `192.168.99.254`
Restart Portainer inside Vagrant box: `./restart_portainer.sh`
