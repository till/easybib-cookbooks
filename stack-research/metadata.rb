name              'stack-research'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'research roles'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'apache-solr'
depends 'composer'
depends 'ies'
depends 'memcache'
depends 'nginx-app'
depends 'php'
depends 'php-fpm'
depends 'php-pear'
depends 'stack-easybib'
depends 'tideways'
