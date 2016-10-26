name              'docker'
description       'A cookbook to setup docker'
license           'BSD'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu', '12.04.2'

depends 'ies-apt'
depends 'easybib'
