default[:dnsmasq]                  = {}
default[:dnsmasq][:listen_address] = "127.0.0.1"
default[:dnsmasq][:cache_size]     = 5000
default[:dnsmasq][:options]        = ["domain-needed", "bogus-priv", "log-queries"]
