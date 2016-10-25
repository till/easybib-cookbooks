name              'avahi'
maintainer        'Leander Damme, Till Klampaeckel'
maintainer_email  'leander@wesrc.com'
license           'BSD License'
description       'Installs and configures avahi daemon'
version           '0.1'
recipe            'avahi::default', 'Installs avahi'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'ies'
