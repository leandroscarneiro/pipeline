# -*- mode: ruby -*-
# vi: set ft=ruby :

LIBVIRT_HOST = ENV['LIBVIRT_HOST'] || "10.10.10.195"

required_plugins = %w(vagrant-hostsupdater vagrant-puppet-install vagrant-libvirt)
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure("2") do |config|

  machines=[
    { :hostname => "gitlab",  :ipPriv => "192.168.122.100", :ipPub => "192.168.2.100", :box => "centos/7", :ram => 2560, :cpu => 1, :mac => "01" },
    { :hostname => "jenkins", :ipPriv => "192.168.122.101", :ipPub => "192.168.2.101", :box => "centos/7", :ram => 2560, :cpu => 1, :mac => "02" },
    { :hostname => "slave1",  :ipPriv => "192.168.122.102", :ipPub => "192.168.2.102", :box => "centos/7", :ram => 512,  :cpu => 1, :mac => "03" },
  ]

  machines.each do |machine|
      config.puppet_install.puppet_version = "5.5.0" #fixo pois ao tentar instalar o 5.5.1 dava erro,  voltar para :latest assim que possivel
      config.vm.define machine[:hostname] do |node|
          node.vm.network :private_network, :ip => machine[:ipPriv], :mode => "nat"
          if ENV['LIBVIRT_HOST']
            node.vm.network "public_network", :dev => "br0", :bridge => "br0", :ip => machine[:ipPub]
          else
            node.vm.network "public_network", :dev => "br0", :bridge => "br0", :use_dhcp_assigned_default_route => "true", :mac => "52:54:00:FF:FF:" + machine[:mac] #MAC fixo para receber mesmo ip do dhcp
          end
          node.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_udp: false, nfs_version: 3
          node.vm.box = machine[:box]
          node.hostsupdater.aliases = [ machine[:hostname] ]
          node.vm.hostname = machine[:hostname] + ".libvirt"
          node.vm.provider :libvirt do |libvirt|
             libvirt.host = LIBVIRT_HOST
             libvirt.username = "root"
             libvirt.id_ssh_key_file = "/opt/id_rsa_libvirt"
             libvirt.connect_via_ssh = true
             libvirt.storage_pool_name = "HDs"
             libvirt.graphics_type = "vnc"
             libvirt.keymap = "pt-br"
             libvirt.suspend_mode = "managedsave"
             libvirt.features = [ 'acpi', 'apic', 'pae' ]
             libvirt.graphics_ip = '0.0.0.0'
             libvirt.nested = true #ativa a virtualizacao dentro de uma VM https://github.com/torvalds/linux/blob/master/Documentation/virtual/kvm/nested-vmx.txt
             libvirt.cpus = machine[:cpu]
             libvirt.memory = machine[:ram]
             #libvirt.storage :file, :size => '50G', :type => 'qcow2'
          end
      end
  end

  config.vm.provision "shell", inline: <<-END_OF_SHELL
    puppet module install puppetlabs-java
    puppet module install puppetlabs-docker
    puppet module install saz-sudo
  END_OF_SHELL

end
