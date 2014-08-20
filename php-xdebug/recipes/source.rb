include_recipe "php-fpm::source"

php_pecl "xdebug" do
  version xdebug_version
  zend_extensions ['xdebug.so']
  config_directives node['xdebug']['config']
  action [ :install, :setup ]
end
