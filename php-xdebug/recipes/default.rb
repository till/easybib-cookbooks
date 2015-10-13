include_recipe 'php-fpm::service'

package 'php5-easybib-xdebug' do
  action :install
end

template "#{node['php-fpm']['prefix']}/etc/php/xdebug-settings.ini" do
  source 'xdebug.ini.erb'
  mode   '0644'
  variables(
    :name => 'xdebug',
    :directives => node['xdebug']['settings']
  )
  notifies :reload, 'service[php-fpm]', :delayed
end
