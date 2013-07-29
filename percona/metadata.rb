name              "percona"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "New BSD License"
description       "Installs and configures Percona Server."
version           "0.1"
recipe            "percona::server", "Installs Percona-Server"
recipe            "percona::repository", "Repository setup and key import"

supports 'ubuntu'
