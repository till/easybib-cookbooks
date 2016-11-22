name             'ies-sinopia'
maintainer       'Brian Wiborg'
maintainer_email 'bwiborg@chegg.com'
license          'Apache 2.0'
description      'Wrapper around sinopia cookbook containing some IES specific patches.'
version          '0.1.0'
source_url       'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url       'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

depends 'sinopia'
