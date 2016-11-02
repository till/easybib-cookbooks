name              'elasticsearch'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Setup Elasticsearch'
version           '0.1'
recipe            'elasticsearch::default', 'Installs elasticsearch'
recipe            'elasticsearch::service', 'Service definitions for elasticsearch'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'
