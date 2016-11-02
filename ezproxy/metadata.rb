name              'ezproxy'
maintainer        'Till Klampaeckel'
maintainer_email  'till@lagged.biz'
license           'BSD License'
description       'Installs the EzProxy proxy server.'
version           '0.1'
recipe            'ezproxy::server', 'Installs EzProxy'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'
