default['stack-easybib']['static_extensions'] = %w(jpg jpeg gif png css js ico woff ttf eot map ico svg)

default['nginx-app']['browser_caching']['enabled'] = false
default['nginx-app']['browser_caching']['config']['eot|ttf|woff'] = {
  'expires' => 'max',
  'headers' => [
    'Access-Control-Allow-Origin *'
  ]
}

default['nginx-app']['browser_caching']['config']['jpg|jpeg|png|gif|ico'] = {
  'expires' => 'max',
  'headers' => [
    'Cache-Control "public, must-revalidate, proxy-revalidate"',
    'Pragma public'
  ]
}

default['nginx-app']['browser_caching']['config']['css|svg|map|js'] = {
  'expires' => 'max',
  'headers' => [
    'Cache-Control "public, must-revalidate, proxy-revalidate"',
    'Pragma public',
    'Vary "Accept-Encoding"'
  ]
}
default['stack-easybib']['php_version'] = '5.6'
default['php']['extensions'] = {}
default['php']['extensions']['config_dir'] = "etc/php/#{node['stack-easybib']['php_version']}/mods-available"
default['php']['ppa'] = {
  'name' => 'ondrejphp',
  'uri' => 'ppa:ondrej/php',
  'package_prefix' => "php#{node['stack-easybib']['php_version']}"
}
default['php-apc']['package_prefix'] = 'php'
default['gearmand']['package_prefix'] = 'php'
default['gearmand']['name'] = 'php-gearman'

default['php-fpm']['prefix'] = ''
default['php-fpm']['exec_prefix'] = '/usr'
default['php-fpm']['fpm_config'] = "etc/php/#{node['stack-easybib']['php_version']}/fpm/php.ini"
default['php-fpm']['cli_config'] = "etc/php/#{node['stack-easybib']['php_version']}/cli/php.ini"
default['php-fpm']['pool_dir'] = "etc/php/#{node['stack-easybib']['php_version']}/fpm/pool.d"
default['php-fpm']['socketdir'] = '/var/run/php'
default['php-fpm']['pid'] = "/var/run/php/php#{node['stack-easybib']['php_version']}-fpm.pid"
default['php-fpm']['user'] = 'www-data'
default['php-fpm']['group'] = 'www-data'
