include_recipe "php-fpm::source"

if node["xdebug"]["version"] == 'latest'
  xdebug_version = nil
end

php_pecl "xdebug" do
  version xdebug_version
  zend_extensions ['xdebug.so']
  config_directives node['xdebug']['config']
  action [ :install, :setup ]
  not_if do
    node["apt"]["easybib"]["ppa"] == "ppa:easybib/php55"
  end
end

package "php5-easybib-xdebug" do
  action :install
  only_if do
    node["apt"]["easybib"]["ppa"] == "ppa:easybib/php55"
  end
end