include_recipe 'ohai'
include_recipe 'supervisor'

# db
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'
include_recipe 'apache-couchdb'

# frontend
include_recipe 'nodejs'
include_recipe 'nodejs::npm'

package 'build-essential'
package 'g++'

include_recipe 'stack-scholar::role-scholar'
include_recipe 'stack-scholar::role-consumer'
include_recipe 'php::module-pdo_sqlite'
include_recipe 'nginx-app::vagrant-silex'

# easybib-api + id
include_recipe 'memcache'

# realtime
include_recipe 'redis::default'

# ssl
include_recipe 'easybib-deploy::ssl-vagrant'

# fake sqs for local simulation of aws sqs
include_recipe 'fakesqs'
