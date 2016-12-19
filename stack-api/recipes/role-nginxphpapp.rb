if node['easybib']['cluster_name'] == 'API Staging'
  # TODO: refactor/generalize this with stack-easybib::role-vagrant
  php_version = '5.6'

  node.normal['php']['extensions']['config_dir'] = "etc/php/#{php_version}/mods-available"
  node.normal['php']['ppa'] = {
    'name' => 'ondrejphp',
    'uri' => 'ppa:ondrej/php',
    'package_prefix' => "php#{php_version}"
  }

  node.normal['php-apc']['package_prefix'] = 'php'

  php_core_deps = %W(
    php#{php_version}-fpm
    php#{php_version}-cli
    php#{php_version}-mbstring
    php#{php_version}-mysql
    php#{php_version}-curl
    php#{php_version}-bcmath
    php#{php_version}-dom
    php#{php_version}-soap
    php#{php_version}-zip
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
    'user' => 'www-data',
    'group' => 'www-data'
  }
end

link '/usr/local/bin/php' do
  to '/usr/bin/php'
end

include_recipe 'ies::role-phpapp'
include_recipe 'php::module-soap'
include_recipe 'php::module-tidy'

include_recipe 'php::module-sybase' if node['easybib']['cluster_name'] == 'API Staging'

if is_aws
  include_recipe 'stack-api::deploy-silex'
else
  include_recipe 'nginx-app::vagrant-silex'
end
