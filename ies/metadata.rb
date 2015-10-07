name              'ies'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Our generic setup and install scripts across all stacks'
version           '0.1'
recipe            'ies::setup', 'Base package sets for all instances'

supports 'ubuntu'

depends 'apt'
depends 'chef_handler_sns'
depends 'easybib'
depends 'fail2ban'
