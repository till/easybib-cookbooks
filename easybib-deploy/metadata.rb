name              'easybib-deploy'
maintainer        'Till Klampaeckel, Ulf Harnhammar'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Deploys easybib'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'aptly'
depends 'bibcd'
depends 'satis'
depends 'php-fpm'
depends 'monit'
depends 'nginx-app'
depends 'easybib'
depends 'pecl-manager'
depends 'haproxy'
