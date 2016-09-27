include_recipe 'ohai'
include_recipe 'supervisor'

include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'

include_recipe 'fake-sqs'

include_recipe 'fake-s3'

include_recipe 'stack-scholar::role-scholar'
include_recipe 'php::module-zip'
include_recipe 'php::module-pdo_sqlite'
include_recipe 'nginx-app::vagrant-silex'

include_recipe 'stack-wpt::role-libreoffice'
include_recipe 'stack-wpt::role-languagetool'
include_recipe 'stack-wpt::role-nodejs'
include_recipe 'redis'
