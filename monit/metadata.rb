name              'monit'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
version           '0.1'
license           'BSD License'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

depends 'easybib'
depends 'gearmand'
depends 'nginx-app'
