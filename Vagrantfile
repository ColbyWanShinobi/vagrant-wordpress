# -*- mode: ruby -*-
# vi: set ft=ruby :

#Don't change this unless you know what you are doing
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #This is the name of the "box" or base image we're basing our server on
  config.vm.box = "ubuntu/jammy64"

  #Private network because we don't want traffic from outside our host OS
  config.vm.network "private_network", ip: "192.168.56.187"
  #config.vm.network "public_network"
  # config.vm.network "private_network", type: "dhcp"

  #This is the name of the server that you see in all the status messages during the "up" process
  config.vm.define "Vagrant Local Wordpress" do |vagrant_local_wordpress|
  end

  # config.vm.synced_folder "html/", "/var/www/html/"

  #Execute this script to begin the provisioning process. This script should be in the same directory as this file.
  config.vm.provision "shell", path: "provision.sh"

  config.vm.provider "virtualbox" do |vb|
    #I do not want to see the VirtualBox GUI every time I start this machine
    vb.gui = false

    #This is the name of the VM as seen in the VirtualBox GUI
    vb.name = "Local Wordpress (vagrant)"

    #This is the amount of RAM you want your virtual server to have
    #Note! The server will run with 1GB of ram but I was unable to compile the code with less than 2GB of RAM.
    vb.memory = "2048"

    #This is the number of CPUs you want your server to have
    vb.cpus = "1"
  end
end
