# Documentation link
https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-virtualbox/

# Download VBox OVA
https://fedoraproject.org/coreos/download/?stream=stable
choose the OVA file

# Create Butane config
Generate a password hash with
```bash
docker run -it --rm quay.io/coreos/mkpasswd --method=yescrypt
```

Create file `example.bu`
```yaml
variant: fcos
version: 1.4.0
passwd:
  users:
    - name: core
      password_hash: $y$j9T$I0QL6S6wHufJVFPyShadl/$FD7cmIqPdnmcNa2wNNekI4XgejTCbxRhyspmWOfclFA
storage:
  files:
    - path: /etc/vconsole.conf
      mode: 0644
      contents:
        inline: KEYMAP=fr
```
Replace the password hash with what was previously generated (the example uses `password` hash)
Change your keymap if needed

# Generate Ignition config
```bash
docker run -i --rm quay.io/coreos/butane:release --pretty --strict < example.bu > example.ign
```
# Following commands with use
VM_NAME=coreos

# Create the VM
VBoxManage import --vsys 0 --vmname "coreos" fedora-coreos-38.20230609.3.0-virtualbox.x86_64.ova

# Insert Ignition config to VM
VBoxManage guestproperty set "coreos" /Ignition/Config "$(cat example.ign)"

# Start VM
VBoxManage startvm "coreos"

# Disable SELinux
sudo sed -i -e 's/SELINUX=/SELINUX=disabled #/g' /etc/selinux/config
sudo systemctl reboot

# Change keyboard layout
sudo localectl set-keymap fr