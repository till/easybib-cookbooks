name              'ies-ssl'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'Apache-2.0'
description       'Create self-signed certificates'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'haproxy'
