case $::facts['os']['family'] {
  'redhat': {
    if $::facts['os']['name'] != 'fedora' {
      package { 'epel-release': 
        ensure => 'present', 
      }
    }
    package { ['libxslt-devel', 'libxml2-devel', 'libvirt-devel', 'libguestfs-tools-c', 'ruby-devel', 'gcc', 'libvirt', 'qemu-kvm']:
      ensure => 'present',
    }
  }
  'debian': {
    package { ['build-dep', 'vagrant', 'ruby-libvirt', 'qemu', 'libvirt-bin', 'ebtables', 'dnsmasq', 'libxslt-dev', 'libxml2-dev', 'libvirt-dev', 'zlib1g-dev', 'ruby-dev']:
      ensure => 'present',
     }
  }
  default: {
    notify { "$::facts['os']['family'] nao suportado": }
  }
}
