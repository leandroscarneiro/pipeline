node 'slave', 'slave1'   {

#========================= FIX ME =====================================
  host { 'gitlab.libvirt':
    ensure       => 'present',
    host_aliases => ['gitlab', 'centos1'],
    ip           => '192.168.122.100'
  }

  host { 'jenkins.libvirt':
    ensure       => 'present',
    host_aliases => ['jenkins', 'centos2'],
    ip           => '192.168.122.102'
  }

  host { 'slave1.libvirt':
    ensure       => 'present',
    host_aliases => ['slave1', 'centos3'],
    ip           => '192.168.122.103'
  }
#========================= FIX ME =====================================


  file { [ '/data' , '/data/docker' ] :
    ensure => 'directory',
  }
  -> file { '/var/lib/docker' :
    ensure => 'link',
    target => '/data/docker',
    before => Class['::docker'],
  }

  group { 'docker' :
    ensure => 'present',
  }
  user { 'jenkins' :
    ensure     => 'present',
    managehome => true,
    shell      => '/bin/bash',
    groups     => [ 'docker' ],
    home       => '/data/jenkins',
  }
  -> ssh_authorized_key { 'jenkins@master' :
    ensure => 'present',
    user   => 'jenkins',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCZyxrh8KPR/rKpzpomNXZM1b12QRmJDKxrVhGAGHCRnjWS+75Vh3S0vCUoFgfy8p7Nl/PbabHRwCV0NPM17EhJ0burH/IWGY/B14jonzEF+HpK1joSObA5uyW2sSUROVhaCmhj4xGl+6NpHhrCETEirwAOPgShKlXHJZi89XMlo5nSkng1f5x2pwumIBKujKn/1cVbVOhj0PQ7Do6ISldmd+m+wkEp34YIb1LHdDimlJD/fRftFRrprvSlO7y+SNPNeT0d+3LxzTe1d3ufHA5aVYlkLhoZY35LZWLUOnfFpyTLtgX4/GxeWsS9xcmmMZZMynDpMNz11C55sM7nLCsp',
  }

  class  { '::docker' : }


  # mod 'saz/sudo'
  class { '::sudo':
    purge               => false,
    config_file_replace => false,
  }

  sudo::conf { 'jenkins':
    content  => "jenkins ALL=NOPASSWD:/opt/puppetlabs/bin/puppet",
  }


  # mod puppetlabs-stdlib puppet-archive puppetlabs-java
  class { '::java': }

  package { [ 'git' ]: 
    ensure => 'present',
  }
}
