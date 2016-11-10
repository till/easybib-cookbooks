name              'easybib'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       "Tools we'd like on all servers."
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'apt'
depends 'chef_handler'
depends 'ies'
depends 'ies-ssl'
depends 'nginx-app'
depends 'php'
depends 'php-fpm'
depends 'wt-data'
depends 'pecl-manager'
