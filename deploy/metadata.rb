name              "deploy"
maintainer        "Till Klampaeckel, Ulf Harnhammar"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Deploys easybib"
version           "0.1"
recipe            "deploy::easybib", "Deploys c0dez!!!1"
recipe            "deploy::playground", "To set-up the correct environment for 'playground'"
recipe            "deploy::ssl", "Deploys nginx as an SSL termination reverse proxy"

supports 'ubuntu'

depends "php-fpm::service"
depends "prosody::default"
depends "nginx-lb::default"
depends "nginx-lb::service"
