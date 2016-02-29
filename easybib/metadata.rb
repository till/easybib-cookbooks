name              'easybib'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       "Tools we'd like on all servers."
version           '0.1'
recipe            'easybib::awscommand', "Installs Timothy Kay's aws command"
recipe            'easybib::nginxstats', 'Script to show current stats.'

supports 'ubuntu'

depends 'apt'
depends 'chef_handler'
depends 'ies'
depends 'easybib-deploy'
depends 'nginx-app'
depends 'php'
