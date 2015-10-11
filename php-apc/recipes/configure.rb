include_recipe 'php-fpm::service'

apc_attributes = node['php-apc'].to_hash
if is_aws
  apc_attributes = { 'stat' => 0,
                     'slam_defense' => 1,
                     'max_file_size' => '2M' }.merge(apc_attributes)
end

template "#{node['php-fpm']['prefix']}/etc/php/apc-settings.ini" do
  source 'apc.ini.erb'
  mode   '0644'
  variables(
    'name' => 'apc',
    'directives' => apc_attributes
  )
  notifies :reload, 'service[php-fpm]', :delayed
end
