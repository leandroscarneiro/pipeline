node 'centos2'   {

#========================= FIX ME =====================================
$private = @(EOT)
    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAmcsa4fCj0f6yqc6aJjV2TNW9dkEZiQysa1YRgBhwkZ41kvu+
    VYd0tLwlKBYH8vKezZfz22mx0cAldDTzNexISdG7qx/yFhmPwdeI6J8xBfh6StY6
    EjmwObsltrElETlYWgpoY+MRpfujaR4awhExIq8ADj4EoSpVxyWYvPVzJaOZ0pJ4
    NX+cdqcLpiASroyp/9XFW1ToY9D0Ow6OiEpXZnfpvsJBKd+GCG9Sx3Q4ppSQ/30X
    7RUa6a70pTu8vkjTzXk9Hfty8c03tXd7nxwOWlWJZC4aGWN+S2Vi1Dp3xacky7YF
    +PxsXlrEvcXJpjGWTMpw6TDc9dQuebDO5ywrKQIDAQABAoIBAAFqP/4SM7+r40Ly
    trJhTYxZbxvWb4C2UCPQr+qIzwhX91A55r9stqMvE/xxb3NJzjJAEqtTJqKybOXL
    0u0NFoEvX9WsPpL7ezoiXI0fYdkXNzDXFcOzKi7tzOQIbzngWDLD47//h9sKHK/L
    6h0dAWG7UHnREkPVWuKxMt2SOJQBELMugm3o1ldPDOf+sdJ4C8uwvj1FtsuPKiLm
    BlevXww5ZZGFbPKS5FVWAujgXdjTsibFE0IQJpNf24steJiBcgsBfsBMD7YGydpG
    cvsIulr/3nctCNwgDGI0hc0JqGQsfhJ6uK1HwClcceKJ7FFfJ16h4JIE0Qvu5+w9
    dJSu0G0CgYEAy7r3gkUVX4wBNMGV3GjHba3ZK1UvRj5sgi+aD1fEBVSI5z1cYRhW
    aDc+FPbGoAbiTtlEUTPvOcoUe5Qkwg44ZoAQnr9XtYSRPXXRitGxcxhiOqMP4OHm
    kapyq83qk4buXts6XQgmjFVQk2I3qRrzYJvMr7hpnL1V8+onMR/GfIsCgYEAwUBF
    yuHeCDYM6Y2tht3QKVPhde5kb+8RXTcdXOy4Gw0TLx4OpQ6hx4m4/cGzqD/xhk2b
    ruPadsO3zRyL0zcNOORRXzNqbE0ucYS4gxCePEaGbU1uBcdyhO6t76z2jiJToJdq
    nKDW9hBslSHmEY9JyD/1LX5OOmIeV8rQKqs1qZsCgYAVcX5vtbnELsZJuT5+zoB/
    KNc82mB5ckSVh1Ed4Ez/iqBGRo0coyUlHvtn1Xmeilrzlaa9LUw2tvBk+XjM/BYv
    o7ccHmOq9WMcJvSBOgUFakGcjmEzeFN+bYRYVPolwQQB8+02sY7tImWyvZnCMNYB
    CyUGMdDb8InFfJXXc9K+dQKBgDMgyRZLOc4cVsA37rAe4WL9wUnNP59ptcNewJME
    QhVOGUQ/BIrg2yaKpnnklJ6wBDuPLuBPgk4nq+pFYi0IhKQHrAuu87ohlWcNQS/T
    5rl1wz0J3lEDGqZW64fc0AJ8zHlRdjBoUVcas0+lf1Qn/9JOMZTOtO23ZeW+T+Lq
    FzF/AoGBAJYswQNoNZjJ4zTlUrqqjRZK6qxl+9CnZ6co5a8QetR0ehy5eRX5P8I/
    itd2+vJ6lZVyYEZ3fDEE/KtAp/fYDBLBxjq2ozw7DnWrMUKQk+p5fPPS6otTsIwa
    799FUG3GKXBt1WjuFVSR3RAALhqt33CZTk1PmuCK3jMUlbzcbzMe
    -----END RSA PRIVATE KEY-----
    | EOT

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

#========================= FIX ME =====================================


  file { [ '/data' , '/data/docker' ] :
    ensure => 'directory',
  }
  -> file { '/var/lib/docker' :
    ensure => 'link',
    target => '/data/docker',
    before => Class['::docker'],
  }

  file { '/data/jenkins':
    ensure => 'directory',
    owner  => 1000,
    group  => 1000,
  }

  file { '/data/jenkins/.ssh':
    mode => '0700',
    ensure => 'directory',
    owner  => 1000,
    group  => 1000,
  }

  file { '/data/jenkins/.ssh/id_rsa':
    ensure  => 'present',
    owner   => 1000,
    group   => 1000,
    mode    => '0600',
    content => $private,
  }

  file { '/data/jenkins/.ssh/id_rsa.pub':
    ensure  => 'present',
    owner   => 1000,
    group   => 1000,
    content => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZyxrh8KPR/rKpzpomNXZM1b12QRmJDKxrVhGAGHCRnjWS+75Vh3S0vCUoFgfy8p7Nl/PbabHRwCV0NPM17EhJ0burH/IWGY/B14jonzEF+HpK1joSObA5uyW2sSUROVhaCmhj4xGl+6NpHhrCETEirwAOPgShKlXHJZi89XMlo5nSkng1f5x2pwumIBKujKn/1cVbVOhj0PQ7Do6ISldmd+m+wkEp34YIb1LHdDimlJD/fRftFRrprvSlO7y+SNPNeT0d+3LxzTe1d3ufHA5aVYlkLhoZY35LZWLUOnfFpyTLtgX4/GxeWsS9xcmmMZZMynDpMNz11C55sM7nLCsp jenkins@master',
  }

  class  { '::docker' : }

  docker::image { 'jenkins/jenkins':
    image_tag => 'lts',
  }

  docker::run { 'jenkins':
    image   => 'jenkins/jenkins:lts',
    env     => [ 'JAVA_OPTS=-Dhudson.footerURL=http://jenkins.carneiro.ga:8180 -Duser.timezone=America/Sao_Paulo' ],
    volumes => [ '/data/jenkins:/var/jenkins_home' ],
    ports   => ['80:8080', '50000:50000'],
  }

}
