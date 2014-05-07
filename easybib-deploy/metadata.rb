name              "easybib_deploy"
maintainer        "Till Klampaeckel, Ulf Harnhammar"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Deploys easybib"
version           "0.1"

supports 'ubuntu'

depends "bibcd"
depends "satis"
depends "php-fpm"
depends "prosody"
depends "monit"
depends "nginx-app"
depends "nginx-lb"
depends "easybib"
depends "pecl-manager"
