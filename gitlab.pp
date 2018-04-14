node 'centos1'   {

  host { 'gitlab.lan':
    ensure       => 'present',
    host_aliases => ['gitlab', 'centos1'],
    ip           => '192.168.2.121'
  }

  host { 'jenkins.lan':
    ensure       => 'present',
    host_aliases => ['jenkins', 'centos2'],
    ip           => '192.168.2.151'
  }

  host { 'slave1.lan':
    ensure       => 'present',
    host_aliases => ['slave1', 'centos3'],
    ip           => '192.168.2.123'
  }


  file { [ '/data' , '/data/docker', '/data/gitlab', '/data/gitlab/config', '/data/gitlab/logs', '/data/gitlab/data' ] :
    ensure => 'directory',
  }
  -> file { '/var/lib/docker' :
    ensure => 'link',
    target => '/data/docker',
    before => Class['::docker'],
  }

  class  { '::docker' : }

  docker::image { 'gitlab/gitlab-ce':
    image_tag => 'latest',
  }

  docker::run { 'gitlab':
    image    => 'gitlab/gitlab-ce',
    env      => [ 'GITLAB_OMNIBUS_CONFIG=gitlab_rails[\'gitlab_shell_ssh_port\'] = 2222; external_url \'http://gitlab\'; ' ],
    volumes  => [ '/data/gitlab/config:/etc/gitlab', '/data/gitlab/logs:/var/log/gitlab', '/data/gitlab/data:/var/opt/gitlab' ],
    ports    => ['80:80', '443:443', '2222:22'],
    #hostname => 'gitlab.lan',
  }


#  group { 'docker' :
#    ensure => 'present',
#  }
#  user { 'jenkins' :
#    ensure     => 'present',
#    managehome => true,
#    shell      => '/bin/bash',
#    groups     => [ 'docker' ],
#    home       => '/data/jenkins',
#  }
#  -> ssh_authorized_key { 'jenkins' :
#    ensure => 'present',
#    user   => 'jenkins',
#    type   => 'ssh-rsa',
#    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDMYR/x/+vmnTwdiNLDF2W7EM7K+1BGz0y1LJBEGn/DB3Xe9V9uBEgMgHO+Ms8HLlQ3IPN9qGK7X5+3p4QU6JmPcA7huEJ6SaY1zSt5Z8nIldKPWcfMB3yMYbgV5vl5mPbhVtJeeT/9Gk2wZTRoVImmiEl33O9VBwrsLbX6ztJ0GnVJgAcAF9X9xEcETdqVy+LVvlavx5vzqW8YVCSaM0JaSDj6L5XtDOcI3eoQnYpu8J4bzoCzBDJHrCffOX0OSZPu6uEqtrQl3zFpxGyudLxzLKsmanSI1dpC/JQJ4JQvMU9/6q+xo/lK3hRpUrkAF8E889oh33DEr33BVovYiMI9',
#  }



}

