class chassis-apt-proxy (
  $config
) {
  if ( $config[apt_proxy] ) {
    stage { "preinstall_apt_proxy":
      before => Stage['main'],
    }
    class { "chassis-apt-proxy::config":
      config => $config[apt_proxy],
      stage  => preinstall_apt_proxy,
    }
  }
}

class chassis-apt-proxy::config (
  $config
) {
  $file = $config[file] ? {
    default => $config[file],
    ''      => '01proxy'
  }
  $http = $config[http] ? {
    default => $config[http],
    ''      => 'false'
  }
  $https = $config[https] ? {
    default => $config[https],
    ''      => 'false'
  }

  $fullpath = "/etc/apt/apt.conf.d/${file}"

  # If only "false" locations are found, delete the proxy file.
  if $http != "false" or $https != "false" {
    file { "apt-proxy add configuration":
      path    => "${fullpath}",
      content => "Acquire::http::Proxy \"${http}\";\nAcquire::https::Proxy \"${https}\";"
    }
  } else {
    file { "apt-proxy remove configuration":
      path   => "${fullpath}",
      ensure => absent
    }
  }
}
