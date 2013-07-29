name              "redis"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Installs and configures redis server."
version           "0.1"
recipe            "redis::server", "Installs redis from source"
recipe            "redis::monit", "Installs related to monitor redis through monit"

supports 'ubuntu'
