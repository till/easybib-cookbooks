name              'haproxy'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
version           '0.2'

depends 'rsyslogd'
depends 'monit'
depends 'easybib'
depends 'ies-letsencrypt'
depends 'ies-ssl'

license 'BSD License'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)
