$apt_proxy_config = sz_load_config()

if $apt_proxy_config[apt_proxy] {
	class {"apt-proxy":
		file  => $apt_proxy_config[apt_proxy][file],
		http  => $apt_proxy_config[apt_proxy][http],
		https => $apt_proxy_config[apt_proxy][https],
	}
}