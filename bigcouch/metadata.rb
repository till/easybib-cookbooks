maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Installs and configures a single-node BigCouch test cluster."
version           "0.1"
recipe            "bigcouch::setup", "Installs BigCouch"
recipe            "bigcouchdb::prepare", "Installs dependencies"

supports 'ubuntu'
