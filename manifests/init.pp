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

  $initFile = $::osfamily ? {
    'RedHat' => '/etc/systemd/system/xvfb.service',
    default  => '/etc/init.d/xvfb'
  }

  $templateFile = $::osfamily ? {
    'RedHat' => "${module_name}/xvfb.service.erb",
    default  => "${module_name}/xvfb.erb"
  }

  $mode = $::osfamily ? {
    'RedHat' => '0644',
    default  => '0755'
  }

  file { $initFile:
    content => template($templateFile),
    mode    => $mode,
    require => Package[$package]
  }

  service { 'xvfb':
    ensure  => running,
    enable  => true,
    require => [ Package[$package], File[$initFile] ]
  }
}

