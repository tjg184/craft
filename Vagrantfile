# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
Vagrant.require_version '>= 1.5.0'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = 'craft-berkshelf'
  config.vm.network :private_network, type: 'dhcp'
  config.vm.network "forwarded_port", guest: 80, host: 8080

  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = 'latest'
  end

  config.vm.define "local", primary: true do |local|
    local.vm.box = 'ubuntu/trusty64'
    local.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.memory = 4096
      vb.cpus = 4
  	end
  end

  # This shares the folder and sets very liberal permissions
  config.vm.synced_folder ".", "/vagrant",
    :owner => 'www-data',
    :group => 'www-data',
    :mount_options => ['dmode=777,fmode=777']

  config.vm.synced_folder "craft/storage/runtime", "/vagrant/craft/storage/runtime", disabled: true

  config.vm.provision :chef_zero do |chef|
    chef.cookbooks_path = "cookbooks"

    chef.json = {
      "craft" => {
        "mode" => {
        	"dev" => true
        }
      } ,
      "run_list" => [
        "recipe[craft::default]"
      ]
    }
  end

end
