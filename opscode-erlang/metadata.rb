name             'opscode-erlang'
maintainer       'Opscode'
maintainer_email 'jpl@opscode.com'
license          'All rights reserved'
description      'Installs/Configures opscode-erlang'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

#depends "erlang_binary", "~> 0.0.3"
depends "runit", "~> 0.13" # internal fork
#depends "deployment-notifications", "~> 0.1.0"
#depends "opscode_extensions", "~> 1.0.2" # for s3 artifacts
depends "logrotate"
#depends "git"
