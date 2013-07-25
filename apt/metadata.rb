name              "apt"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "Apache 2.0"
description       "Configures apt and apt services"
version           "0.10.0"
recipe            "apt", "Runs apt-get update during compile phase and sets up preseed directories"
recipe            "apt::cacher", "Set up an APT cache"
recipe            "apt::proxy", "Set up an APT proxy"
recipe            "apt::ppa", "Setup the tools needed to initialize PPAs"
recipe            "apt::repair", "Install apt-repair-sources"

%w{ ubuntu debian }.each do |os|
  supports os
end
