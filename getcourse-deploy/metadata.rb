name              "getcourse-deploy"
maintainer        "Till Klampaeckel"
license           "BSD License"
description       "Deploys easybib"
version           "0.1"

supports 'ubuntu'

depends "bibcd"
depends "easybib"
depends "monit"
depends "nginx-app"
depends "nginx-lb"
depends "pecl-manager"
depends "percona"
depends "php-fpm"
depends "satis"
