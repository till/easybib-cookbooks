name              'satis'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Tools for the satis repo'
version           '0.1'
recipe            'satis::s3-syncer', 'Deploys s3-syncer for composer-s3-bindings'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'easybib'
depends 'nginx-app'
