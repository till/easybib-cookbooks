include_recipe 'php-fpm::service'

if node['xdebug']['version'] == 'latest'
  xdebug_version = nil
end

if node['apt']['easybib']['ppa'] != 'ppa:easybib/php55'
  include_recipe 'php-fpm::source'
end

php_pecl 'xdebug' do
  version xdebug_version
  zend_extensions ['xdebug.so']
  config_directives node['xdebug']['config']
  action [ :install, :setup ]
  not_if do
    node['apt']['easybib']['ppa'] == 'ppa:easybib/php55'
  end
end

package 'php5-easybib-xdebug' do
  action :install
  only_if do
    node['apt']['easybib']['ppa'] == 'ppa:easybib/php55'
  end
end

template "#{node['php-fpm']['prefix']}/etc/php/xdebug-settings.ini" do
  source 'xdebug.ini.erb'
  mode   '0644'
  variables(
    :config => node['xdebug']['config']
  )
  notifies :reload, 'service[php-fpm]', :delayed
  only_if do
    node['apt']['easybib']['ppa'] == 'ppa:easybib/php55'
  end
end
