# -*- mode: ruby -*-
# vi: set ft=ruby :

begin
  # requires librarian-chef plugin
  require "librarian/action"

  # workaround for shared folders with vmware and lxc providers
  # see https://github.com/applicationsonline/librarian/issues/151
  class Librarian::Action::Install < Librarian::Action::Base
    def create_install_path
      if install_path.exist?
        FileUtils.rm_rf("#{install_path}/.", secure: true)
      end
      install_path.mkpath
    end
  end
rescue LoadError
  $stderr.puts "Please install librarian-chef plugin with \"vagrant plugin install librarian-chef\""
  exit
end

def installed_plugins(required_plugins)
  required_plugins.reduce([]) do |missing, plugin|
    if Vagrant.has_plugin?(plugin)
      missing
    else
      puts "#{plugin} plugin is missing. Installing..."
      %x(set -x; vagrant plugin install #{plugin})
      missing << plugin
    end
  end
end

def load_env
  # requires dotenv plugin/gem
  require "dotenv"

  # use .env.example if .env doesn't exist
  # load ENV variables from .env, where all user-specific configuration settings are stored
  FileUtils.cp '.env.example', '.env' unless File.exist?('.env')
  Dotenv.load!
rescue LoadError
  $stderr.puts "Please install dotenv plugin with \"vagrant plugin install dotenv\""
  exit
end

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here.

  # Check if required plugins are installed.
  required_plugins = %w{ vagrant-omnibus vagrant-librarian-chef vagrant-bindfs dotenv }

  unless installed_plugins(required_plugins).empty?
    puts "Plugins have been installed, please rerun vagrant."
    exit
  end

  # load ENV variables
  load_env

  # Install latest version of Chef
  config.omnibus.chef_version = :latest

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "chef/ubuntu-14.04"

  # Override settings for specific providers
  config.vm.provider :virtualbox do |vb, override|
    vb.name = "lagotto"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    unless Vagrant::Util::Platform.windows?
      # Disable default synced folder before bindfs tries to bind to it
      override.vm.synced_folder ".", "/var/www/lagotto/current", disabled: true
      override.vm.synced_folder ".", "/vagrant", id: "vagrant-root", nfs: true
      override.bindfs.bind_folder "/vagrant", "/var/www/lagotto/current",
        :owner => "900",
        :group => "900",
        :"create-as-user" => true,
        :perms => "u=rwx:g=rwx:o=rwx",
        :"create-with-perms" => "u=rwx:g=rwx:o=rwx",
        :"chown-ignore" => true,
        :"chgrp-ignore" => true,
        :"chmod-ignore" => true
    end
  end

  config.vm.provider :vmware_fusion do |fusion, override|
    fusion.vmx["memsize"] = "1024"
  end

  config.vm.provider :aws do |aws, override|
    # please configure in .env
    aws.access_key_id = ENV.fetch('AWS_KEY')
    aws.secret_access_key = ENV.fetch('AWS_SECRET')
    aws.keypair_name = ENV.fetch('AWS_KEYNAME')
    override.ssh.private_key_path = ENV.fetch('AWS_KEYPATH')

    aws.security_groups = "default"
    aws.instance_type = "m3.medium"
    aws.ami = "ami-9aaa1cf2"
    aws.region = "us-east-1"
    aws.tags = { Name: 'Vagrant Lagotto' }

    override.ssh.username = "ubuntu"
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
  end

  # config.vm.provider :digital_ocean do |digital_ocean, override|
  #   # please configure in .env
  #   override.ssh.private_key_path = ENV.fetch('PRIVATE_KEY_PATH')
  #   digital_ocean.token = ENV.fetch('DO_PROVIDER_TOKEN')
  #   digital_ocean.size = ENV.fetch('DO_SIZE')

  #   override.vm.box = 'digital_ocean'
  #   override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
  #   override.ssh.username = "ubuntu"
  #   digital_ocean.region = 'nyc2'
  #   digital_ocean.image = 'Ubuntu 14.04 x64'
  # end

  config.vm.hostname = ENV.fetch('HOSTNAME')
  config.vm.network :private_network, ip: ENV.fetch('PRIVATE_IP')
  config.vm.network :public_network
  config.vm.synced_folder ".", "/var/www/lagotto/current", id: "vagrant-root"

  # Enable provisioning with chef solo
  config.vm.provision :chef_solo do |chef|
    chef.custom_config_path = "Vagrantfile.chef"
    chef.cookbooks_path = "vendor/cookbooks"
    dna = JSON.parse(File.read("node.json"))
    dna.delete("run_list").each do |recipe|
      chef.add_recipe(recipe)
    end
    chef.json.merge!(dna)
  end
end
