maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "PHP License"
description       "Installs and configures PHP with fpm patch."
version           "0.1"
recipe            "php-fpm::install", "Installs PHP-fpm"
recipe            "php-fpm::prepare", "Creates prequesites like user and directories"

supports 'ubuntu'