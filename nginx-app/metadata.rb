name              "nginx-app"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Installs and configures an nginx for our appservers."
version           "0.1"
recipe            "nginx-app::server", "Installs Nginx"
recipe            "nginx-app::configure", "Configures virtualhost, etc."

depends "php-fpm"
depends "apt"

supports 'ubuntu'
