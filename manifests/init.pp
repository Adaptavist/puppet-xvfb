class xvfb(
  $user    = 'hosting',
  $options = ':99 -ac'
){

  case $::osfamily {
    'Debian': {
      $package = 'xvfb'
    }
    'RedHat': {
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

  $init_file = $::osfamily ? {
    'RedHat' => '/etc/systemd/system/xvfb.service',
    default  => '/etc/init.d/xvfb'
  }

  $template_file = $::osfamily ? {
    'RedHat' => "${module_name}/xvfb.service.erb",
    default  => "${module_name}/xvfb.erb"
  }

  $mode = $::osfamily ? {
    'RedHat' => '0644',
    default  => '0755'
  }

  file { $init_file:
    content => template($template_file),
    mode    => $mode,
    require => Package[$package]
  }

  service { 'xvfb':
    ensure  => running,
    enable  => true,
    require => [ Package[$package], File[$init_file] ]
  }
}

