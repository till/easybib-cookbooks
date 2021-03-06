name              'stack-api'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'API roles'
version           '0.2'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'easybib'
depends 'ies'
depends 'nginx-app'
depends 'php'
depends 'php-fpm'
depends 'vpc-classiclink'
