## Spin a 2 nodes cluster

K3S_TOKEN=1234 docker-compose up -d
K3S_TOKEN=1234 docker-compose down

docker volume rm k3s_k3s-server


https://github.com/k3s-io/k3s/issues/734#issuecomment-881296413


## Deploy portainer

docker exec k3s-server-1 kubectl apply -n portainer -f https://downloads.portainer.io/ce2-17/portainer.yaml


## Use vagrant
```vagrant
ENV["TERM"]="linux"

Vagrant.configure("2") do |config|
  
  # set the image for the vagrant box
  config.vm.box = "opensuse/Leap-15.2.x86_64"
  ## Set the image version
  # config.vm.box_version = "15.2.31.212"

  # st the static IP for the vagrant box
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.hostname = "k3s-vagrant"
  
  # consifure the parameters for VirtualBox provider
  config.vm.provider "virtualbox" do |vb|
    vb.name = "
    vb.memory = "4096"
    vb.cpus = 4
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
end
```

```sh
vagrant up
vagrant status
vagrant ssh
```
### Install k3s

See https://devops.stackexchange.com/a/16044

```sh
curl -sfL https://get.k3s.io | sh -
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
source .bashrc
mkdir ~/.kube 2> /dev/null
sudo /usr/local/bin/k3s kubectl config view --raw > "$KUBECONFIG"
chmod 600 "$KUBECONFIG"

```
