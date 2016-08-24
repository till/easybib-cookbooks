include_recipe 'ohai'
include_recipe 'supervisor'

include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'

include_recipe 'fake-sqs'

node.set['fake-s3']['storage'] = '/vagrant_wpt/var/s3'
include_recipe 'fake-s3'

# frontend
# include_recipe 'nodejs'
# include_recipe 'nodejs::npm'
# package 'build-essential'
# package 'g++'

php_version = node['stack-wpt']['php_version']

# php setup
node.set['php']['extensions']['config_dir'] = "etc/php/#{php_version}/mods-available"
node.set['php']['ppa'] = {
  'name' => 'ondrejphp',
  'uri' => 'ppa:ondrej/php',
  'package_prefix' => "php#{php_version}"
}

node.set['php-apc']['package_prefix'] = 'php'

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

node.set['php-fpm'] = {
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

include_recipe 'stack-scholar::role-scholar'
include_recipe 'php::module-zip'
include_recipe 'php::module-pdo_sqlite'
include_recipe 'nginx-app::vagrant-silex'

apt_repository 'libreoffice-5.2' do
  uri 'ppa:libreoffice/libreoffice-5-2'
  key 'libreoffice-5.2.key'
  distribution node['lsb']['codename']
  components ['main']
end

apt_package 'libreoffice' do
  action :install
  options '--no-install-recommends --no-install-suggests'
end

include_recipe 'java'
lt_conf = node['stack-wpt']['languagetool']

ark 'languagetool' do
  url  "https://languagetool.org/download/LanguageTool-#{lt_conf['version']}.zip"
  version lt_conf['version']
  home_dir lt_conf['path']
  owner node['nginx-app']['user']
  group node['nginx-app']['group']
  checksum lt_conf['checksum']
end
