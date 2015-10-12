# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    # Create a private network, which allows host-only access to the machine using a specific IP.
    config.vm.network "private_network", ip: "192.168.30.20"
    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.boot_timeout = 300
    config.vm.synced_folder "html/", "/usr/share/nginx/html", type: "nfs"
    # Shell provisioning
    config.vm.provision "shell" do |s|
        s.path = "provision.sh"
    end
    # VirtualBox GUI Name
    config.vm.provider "virtualbox" do |v|
        v.name = "Mozilla"
        v.memory = 524
    end
    # VM Name
    # Bringing machine 'Mozilla' up with 'virtualbox' provider...
    config.vm.define :Mozilla do |t|
    config.vm.hostname = "Mozilla"
    end
end
