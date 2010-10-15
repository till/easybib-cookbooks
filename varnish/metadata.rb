maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "PHP License"
description       "Setup varnish's repo and install it."
version           "0.1"
recipe            "varnish::setup", "Setup varnish"
recipe            "varnish::configure", "Configure varnish"
supports 'ubuntu'
