include_recipe 'php-fpm::service'

if node['xdebug']['version'] == 'latest'
  xdebug_version = nil
end

package 'php5-easybib-xdebug' do
  action :install
end

template "#{node['php-fpm']['prefix']}/etc/php/xdebug-settings.ini" do
  source 'xdebug.ini.erb'
  mode   '0644'
  variables(
    :config => node['xdebug']['config']
  )
  notifies :reload, 'service[php-fpm]', :delayed
end
