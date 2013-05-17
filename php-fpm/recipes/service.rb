service_name = "php-fpm"

service "php-fpm" do
  service_name service_name
  supports     [:start, :stop, :reload, :restart]
end
