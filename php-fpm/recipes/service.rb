case node[:lsb][:codename]
when 'lucid'
  service_name = "php-fpm"
when 'precise'
  service_name = "php5-fpm"
end

service "php-fpm" do
  service_name service_name
  supports     [:start, :stop, :reload, :restart]
end
