name              'satis'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Tools for the satis repo'
version           '0.1'
recipe            'satis::s3-syncer', 'Deploys s3-syncer for composer-s3-bindings'

supports 'ubuntu'

depends 'easybib'
depends 'nginx-app'
