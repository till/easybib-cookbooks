php_pecl 'opcache' do
  zend_extensions ['opcache.so']
  config_directives node['php-opcache']['settings']
  action :setup
end

file node['php-opcache']['settings']['error_log'] do
  mode 0755
  owner node['php-fpm']['user']
  group node['php-fpm']['group']
  notifies :restart, 'service[php-fpm]', :delayed
  only_if node['php-opcache']['settings'].attribute?('error_log')
end
