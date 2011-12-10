maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "New BSD License"
description       "Installs and configures Percona Server."
version           "0.1"
recipe            "percona-server::setup", "Installs Percona-Server"
recipe            "percona-server::repository", "Repository setup and key import"

supports 'ubuntu'
