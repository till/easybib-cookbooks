include_recipe "php-fpm::service"

case node[:lsb][:codename]
when 'lucid'
  etc_dir = "#{node["php-fpm"][:prefix]}/etc/php"
when 'precise'
  etc_dir = "#{node["php-fpm"][:prefix]}/etc/php5/conf.d"
end

template "#{etc_dir}/suhosin.ini" do
  source   "suhosin.ini.erb"
  mode     "0644"
  notifies :reload, resources( :service => "php-fpm" ), :delayed
end
