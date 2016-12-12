include_recipe 'ies::role-generic'
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'

include_recipe 'ohai'
include_recipe 'memcache'

# fake sqs for local simulation of aws sqs
include_recipe 'fake-sqs'

# php 5.6 setup
php_version = '5.6'

node.normal['php']['extensions']['config_dir'] = "etc/php/#{php_version}/mods-available"
node.normal['php']['ppa'] = {
  'name' => 'ondrejphp',
  'uri' => 'ppa:ondrej/php',
  'package_prefix' => "php#{php_version}"
}

node.normal['php-apc']['package_prefix'] = 'php'
node.normal['php-gearman']['package_prefix'] = 'php'

php_core_deps = %W(
  php#{php_version}-fpm
  php#{php_version}-cli
  php#{php_version}-mbstring
  php#{php_version}-mysql
  php#{php_version}-curl
  php#{php_version}-bcmath
  php#{php_version}-dom
  php#{php_version}-soap
  php-memcache
)

node.normal['php-fpm'] = {
  'prefix' => '',
  'exec_prefix' => '/usr',
  'fpm_config' => "etc/php/#{php_version}/fpm/php.ini",
  'cli_config' => "etc/php/#{php_version}/cli/php.ini",
  'pool_dir' => "etc/php/#{php_version}/fpm/pool.d",
  'socketdir' => '/var/run/php',
  'pid' => "/var/run/php/php#{php_version}-fpm.pid",
  'packages' => php_core_deps.join(','),
  'user' => 'vagrant',
  'group' => 'vagrant'
}

include_recipe 'stack-easybib::role-phpapp'
include_recipe 'nginx-app::vagrant-silex'
include_recipe 'stack-easybib::role-nginxphpapp'
include_recipe 'stack-service::role-gearmand'
include_recipe 'stack-easybib::role-gearmanw'

include_recipe 'ies-nodejs::repo'
include_recipe 'nodejs::npm'

# mssql server
include_recipe 'php::module-sybase'

# dev dependencies last
include_recipe 'php::module-pdo_sqlite'
include_recipe 'php::module-xdebug'
