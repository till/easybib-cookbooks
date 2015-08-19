include_recipe 'ohai'

# db
include_recipe 'percona::server'
include_recipe 'percona::client'
include_recipe 'percona::dev'
include_recipe 'apache-couchdb'

# frontend
include_recipe 'nodejs'
include_recipe 'nodejs::npm'

include_recipe 'easybib::role-phpapp'
include_recipe 'php-pdo_sqlite'
include_recipe 'nginx-app::vagrant-silex'

# easybib-api + id
include_recipe 'memcache'
include_recipe 'php-intl'

# featureflag-app
include_recipe 'redis::default'

# ssl
include_recipe 'easybib-deploy::ssl-vagrant'
