name             'ies-datadog'
maintainer       'Joel Gilley'
maintainer_email 'jgilley@chegg.com'
license          'Apache 2.0'
description      'Simplified datadog agent installer'
version          '0.0.1'
source_url       'https://github.com/easybiblabs/easybib-cookbooks' if respond_to?(:source_url)
issues_url       'https://github.com/easybiblabs/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'easybib'
