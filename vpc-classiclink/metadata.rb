name              'vpc-classiclink'
maintainer        'Roman Chyr'
maintainer_email  'rchyr@chegg.com'
license           'BSD License'
description       'Installs and configures VPC ClassicLink'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'awscli'
depends 'easybib'
