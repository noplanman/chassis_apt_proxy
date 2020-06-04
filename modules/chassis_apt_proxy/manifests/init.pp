class chassis_apt_proxy (
  $config
) {
  if ( $config[apt_proxy] ) {
    # Force this extension to be run before any others.
    stage { "preinstall_apt_proxy":
      before => Stage['main'],
    }
    class { "chassis_apt_proxy::config":
      config => $config[apt_proxy],
      stage  => preinstall_apt_proxy,
    }
  }
}

class chassis_apt_proxy::config (
  $config
) {
  $file = pick($config[file], "01proxy")
  $http = pick($config[http], "false")
  $https = pick($config[https], "false")

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
