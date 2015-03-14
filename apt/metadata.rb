name              'apt'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'Apache 2.0'
description       'Configures apt and apt services'
version           '2.5.3'
recipe            'apt', 'Runs apt-get update during compile phase and sets up preseed directories'
recipe            'apt::proxy', 'Set up an APT proxy'
recipe            'apt::ppa', 'Setup the tools needed to initialize PPAs'
recipe            'apt::repair', 'Install apt-repair-sources'

recipe            'apt::cacher-ng', 'Set up an apt-cacher-ng caching proxy'
recipe            'apt::cacher-client', 'Client for the apt::cacher-ng caching proxy'

%w(ubuntu).each do |os|
  supports os
end

attribute 'apt/cacher-client/restrict_environment',
          :description => 'Whether to restrict the search for the caching server to the same environment as this node',
          :default => 'false'

attribute 'apt/cacher_port',
          :description => 'Default listen port for the caching server',
          :default => '3142'

attribute 'apt/cacher_interface',
          :description => 'Default listen interface for the caching server',
          :default => nil

attribute 'apt/key_proxy',
          :description => 'Passed as the proxy passed to GPG for the apt_repository resource',
          :default => ''

attribute 'apt/caching_server',
          :description => 'Set this to true if the node is a caching server',
          :default => 'false'

depends 'aptly'
depends 'easybib'
