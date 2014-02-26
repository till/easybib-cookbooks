name              "php-fpm"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "PHP License"
description       "Installs and configures PHP with fpm patch."
version           "0.4"
recipe            "php-fpm::default", "Installs our custom PHP package from launchpad"
recipe            "php-fpm::download", "Downloads the source and extracts it"
recipe            "php-fpm::prepare", "Creates prequesites like user and directories"
recipe            "php-fpm::dependencies", "Install dependencies"
supports 'ubuntu'

depends "apt"
depends "php-apc"
