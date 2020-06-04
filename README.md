# APT Proxy for Chassis

Mini extension to set an APT proxy for your [Chassis][1] box.

If you have an APT proxy running locally or in your local network, this extension allows you to connect to it to speed up provisioning, as all packages will be loaded from the proxy cache.

Tested and fully working with [Apt-Cacher NG][2]

## Installation

*Either...*

Add this extension to your `config.local.yaml`:

```yaml
extensions:
  - noplanman/chassis_apt_proxy
```

*or...*

Clone this repository into your Chassis `extensions` directory:

```sh
# In your Chassis root directory
$ cd extensions
$ git clone https://github.com/noplanman/chassis_apt_proxy
```

## Configuration

Add a new section to your `config.local.yaml`:

```yaml
apt_proxy:
  file: 01proxy                # File name to use when saving to /etc/apt/apt.conf.d (default: 01proxy)
  http: http://127.0.0.1:3142  # HTTP address to your cache proxy (default: false)
  https: false                 # HTTPS address to your cache proxy (default: false)
```

To remove any previously added proxy, just leave the single `http` value blank and provision your box. Only then can you remove the config and extension:
```yaml
apt_proxy:
  http:
```

Now simply provision your box:
```sh
$ vagrant up --provision
```

## TOTAL APT proxy

Since this is a puppet extension for Chassis, it will only be loaded after the initial preprovision script has executed, meaning that the initial APT package installation is unproxied.
If you want those to be proxied too, you will have to add some code to `puppet/preprovision.sh`:
```bash
# -snip- #

  # Remove temp files
  rm /tmp/mirrors-sources.list /tmp/apt-sources.list
fi

# Add APT proxy
echo 'Acquire::http::Proxy "http://your-proxy:3142";' > /etc/apt/apt.conf.d/01proxy
echo 'Acquire::https::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

# Update apt
sudo apt-get update

# -snip- #
```

[1]: https://github.com/Chassis/Chassis "Chassis on GitHub"
[2]: https://www.unix-ag.uni-kl.de/~bloch/acng/ "Apt-Cacher NG"
