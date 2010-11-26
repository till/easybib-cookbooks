maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Installs some scripts and directories."
version           "0.1"
recipe            "teracode-dev::setup", "General setup"
recipe            "teracode-dev::users", "Create user accounts"
recipe            "teracode-dev::sudo", "Setup sudo config and add users to sudo group"
recipe            "teracode-dev::dirfix", "Fix permissions on home directories"

supports 'ubuntu'
