name              'ies-apt'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'Apache 2.0'
description       'Configures apt and apt services'
version           '0.0.1'
recipe            'ies-apt::proxy', 'Set up an APT proxy'
recipe            'ies-apt::ppa', 'Setup the tools needed to initialize PPAs'
recipe            'ies-apt::repair', 'Install apt-repair-sources'

%w(ubuntu).each do |os|
  supports os
end

depends 'apt'
depends 'aptly'
depends 'easybib'
