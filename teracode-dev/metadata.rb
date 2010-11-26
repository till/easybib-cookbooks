maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Installs some scripts and directories."
version           "0.1"
recipe            "teracode-dev::setup", "General setup"
recipe            "teracode-dev::users", "Create user accounts"

supports 'ubuntu'
