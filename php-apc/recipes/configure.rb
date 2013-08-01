include_recipe "php-fpm::service"

is_cloud = is_aws()

template "#{node["php-fpm"][:prefix]}/etc/php/apc.ini" do
  source   "apc.ini.erb"
  mode     "0644"
  variables({
    :is_cloud => is_cloud
  })
  notifies :reload, resources(:service => "php-fpm"), :delayed
end
