class xvfb(
  $user    = 'hosting',
  $options = ':99 -ac'
){

  case $::osfamily {
    Debian: {
      $package = 'xvfb'
    }
    RedHat: {
      $package = 'xorg-x11-server-Xvfb'
    }
    default: {
      fail("xvfb - Unsupported Operating System family: ${::osfamily}")
    }
  }

  unless defined(Package[$package]) {
    package { $package:
      ensure  => installed,
    }
  }

  file { '/etc/init.d/xvfb':
    content => template("${module_name}/xvfb.erb"),
    mode    => '0755',
    require => Package[$package]
  }

  service { 'xvfb':
    ensure  => running,
    enable  => true,
    require => [ Package[$package], File['/etc/init.d/xvfb'] ]
  }
}

