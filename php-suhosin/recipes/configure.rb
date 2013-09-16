include_recipe "php-fpm::service"

etc_dir = "#{node["php-fpm"]["prefix"]}/etc/php"

template "#{etc_dir}/suhosin.ini" do
  source   "suhosin.ini.erb"
  mode     "0644"
  notifies :reload, "service[php-fpm]", :delayed
end
