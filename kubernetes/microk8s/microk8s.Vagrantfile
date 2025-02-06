# https://gist.github.com/JonTheNiceGuy/6ea77cb3e04eed48c4038ca06de3d0ae
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "public_network", 
    use_dhcp_assigned_default_route: true
  config.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 2
    end
  config.vm.provision "shell", inline: <<-EOF
    snap install microk8s --classic
    snap install docker
    microk8s.status --wait-ready
    microk8s.enable dns dashboard registry
    usermod -a -G microk8s vagrant
    echo "alias kubectl='microk8s.kubectl'" > /home/vagrant/.bash_aliases
    chown vagrant:vagrant /home/vagrant/.bash_aliases
    echo "alias kubectl='microk8s.kubectl'" > /root/.bash_aliases
    chown root:root /root/.bash_aliases
  EOF

  config.vm.define "microk8s_a" do |microk8s_a|
    microk8s_a.vm.hostname = "microk8s-a"
    microk8s_a.vm.provider "virtualbox" do |vb|
      vb.name = "microk8s-a"
    end
    microk8s_a.vm.provision "shell", inline: <<-EOF
      export local_ip="$(ip route | grep default | grep enp0s8 | cut -d' ' -f9)"
      microk8s.add-node | grep $local_ip | tee /vagrant/add_k8s
    EOF
  end
  config.vm.define "microk8s_b" do |microk8s_b|
    microk8s_b.vm.hostname = "microk8s-b"
    microk8s_b.vm.provider "virtualbox" do |vb|
      vb.name = "microk8s-b"
    end
    microk8s_b.vm.provision "shell", inline: <<-EOF
      bash -x /vagrant/add_k8s
    EOF
  end
end