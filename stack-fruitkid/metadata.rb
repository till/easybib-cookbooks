name              'stack-fruitkid'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'CitationAPI roles'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'composer'
depends 'ies'
depends 'memcache'
depends 'nginx-app'
depends 'php'
depends 'php-fpm'
depends 'php-pear'
depends 'postfix'
depends 'tideways'
