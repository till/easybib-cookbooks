name              "nodejs"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "New BSD License"
description       "Install nodejs on karmic"
version           "0.1"
recipe            "nodejs::default", "Setup launchpad repo and install 'nodejs'"
supports 'ubuntu'

depends "apt"
