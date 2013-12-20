name              "elasticsearch"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Setup Elasticsearch"
version           "0.1"
recipe            "elasticsearch::default", "Installs elasticsearch"
recipe            "elasticsearch::service", "Service definitions for elasticsearch"

supports 'ubuntu'
