include_recipe "php-fpm::service"

template "/usr/local/etc/php/suhosin.ini" do
  source   "suhosin.ini.erb"
  mode     "0644"
  notifies :reload, resources( :service => "php-fpm" ), :delayed
end

