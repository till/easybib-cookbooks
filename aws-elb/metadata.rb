maintainer        "Till Klampaeckel"
maintainer_email  "tilL@php.net"
license           "BSD License"
description       "Installs a credential file and a start script to be able to register/unregister an instance on an ELB."
version           "0.1"
recipe            "aws-elb::setup", "Installs all components"
recipe            "aws-elb::configure", "Run configuration"

supports 'ubuntu'
