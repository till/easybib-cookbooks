template "/usr/local/etc/php/suhosin.ini" do
  source "suhosin.ini.erb"
  mode   "0644"
end

include_recipe "php-fpm::service"
