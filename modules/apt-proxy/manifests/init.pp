class apt-proxy (
	$file,
	$http,
	$https
) {
	unless $file { $file = "01proxy" }
	unless $http { $http = "false" }
	unless $https { $https = "false" }

	# If only "false" locations are found, delete the proxy file.
	if $http != "false" or $https != "false" {
		exec { "apt-proxy add configuration":
			command => "/bin/echo -e 'Acquire::http::Proxy \"${http}\";\nAcquire::https::Proxy \"${https}\";' > ${file}",
			creates => "/etc/apt/apt.conf.d/${file}",
			cwd     => "/etc/apt/apt.conf.d"
		}
	} else {
		file { "apt-proxy remove configuration":
			path   => "/etc/apt/apt.conf.d/${file}",
			ensure => absent
		}
	}
}
