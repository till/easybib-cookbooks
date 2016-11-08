name              'stack-cmbm'
maintainer        'Brian Wiborg'
maintainer_email  'brian.wiborg@imagineeasy.com'
license           'BSD 2-clause'
description       'CitationMachine and BibMe Roles'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'easybib'
depends 'easybib-deploy'
depends 'haproxy'
depends 'ies'
depends 'ies-mysql'
depends 'ies-rbenv'
depends 'ies-zsh'
depends 'nginx-app'
depends 'nodejs'
depends 'redis'
depends 'supervisor'
depends 'ies-ssl'
