name              "ohai-phpfpm"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "provides php-fpm ohai plugin"
version           "0.1"

supports 'ubuntu'

depends "ohai"

recipe "ohai-phpfpm::default", "Installs php-fpm ohai plugin"
