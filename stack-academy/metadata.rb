name              'stack-academy'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Academy Stack'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'easybib'
depends 'easybib-deploy'
depends 'nginx-app'
depends 'ies'
depends 'ohai'
depends 'ies-mysql'
depends 'php'
depends 'php-fpm'
depends 'nodejs'
depends 'avahi'
depends 'stack-service'
depends 'supervisor'
