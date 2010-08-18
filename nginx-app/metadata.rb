maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Installs and configures an nginx for our appservers."
version           "0.1"
recipe            "nginx::server", "Installs Nginx"
recipe            "nginx::configure", "Configures virtualhost, etc."

supports 'ubuntu'