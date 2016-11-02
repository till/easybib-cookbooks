name              'stack-ops'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'ops infrastructure roles'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'ies'
depends 'php'
depends 'phpmyadmin'
depends 'smokeping'
