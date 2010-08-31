maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Install the additional plugins into ganglia."
version           "0.1"
recipe            "ganglia-plugins::nginx", "Installs the nginx plugin."
recipe            "ganglia-plugins::redis", "Installs the redis plugin."

supports 'ubuntu'