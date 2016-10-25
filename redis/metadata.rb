name              'redis'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Installs and configures redis server.'
version           '0.1'
recipe            'redis::default', 'Installs redis'
recipe            'redis::monit', 'Installs related to monitor redis through monit'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'apt'
depends 'aptly'
depends 'easybib'
