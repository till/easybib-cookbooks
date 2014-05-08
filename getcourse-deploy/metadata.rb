name              "getcourse-deploy"
maintainer        "Till Klampaeckel"
license           "BSD License"
description       "Deploys easybib"
version           "0.1"

supports 'ubuntu'

depends "bibcd"
depends "satis"
depends "php-fpm"
depends "monit"
depends "nginx-app"
depends "nginx-lb"
depends "easybib"
depends "pecl-manager"
