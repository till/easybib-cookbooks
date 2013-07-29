name              "dhcp3"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "DHCP3 configuration - this is to 'inject' a DNScache into the dhcp config on AWS instances"
version           "0.1"
recipe            "dhcp3::configure", "Setup a custom DNS server (currently hardcoded to 127.0.0.1)"
recipe            "dhcp3::service", "Wrap the init.d script."

supports 'ubuntu'
