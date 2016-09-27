default['stack-wpt'] = {
  'languagetool' => {
    'version' => '3.4',
    'path' => '/usr/local/languagetool',
    'checksum' => 'ff36380c5807c5bdc67d222c5f2adeeb0a047a02661885c29cd8297443846c9c'
  }
}

normal['fake-s3']['storage'] = '/vagrant_wpt/var/s3'

# nodejs/npm
normal['nodejs'] = {
  'version' => '4.2.6',
  'install_method' => 'binary',
  'npm' => {
    'version' => '2.14.16'
  }
}

# php setup
php_version = '7.0'

normal['php']['extensions']['config_dir'] = "etc/php/#{php_version}/mods-available"
normal['php']['ppa'] = {
  'name' => 'ondrejphp',
  'uri' => 'ppa:ondrej/php',
  'package_prefix' => "php#{php_version}"
}

normal['php-apc']['package_prefix'] = 'php'

php_core_deps = %W(
  php#{php_version}-fpm
  php#{php_version}-cli
  php#{php_version}-mbstring
  php#{php_version}-mysql
  php#{php_version}-curl
  php#{php_version}-bcmath
  php#{php_version}-dom
  php-memcached
)

normal['php-fpm'] = {
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
