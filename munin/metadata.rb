maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "PHP License"
description       "Munin setup and configuration"
version           "0.1"
recipe            "munin::server", "Install munin"
recipe            "munin::configure", "Configure nodes, etc."
supports 'ubuntu'
