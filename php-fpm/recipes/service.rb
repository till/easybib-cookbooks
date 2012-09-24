service "php-fpm" do
  service_name "php-fpm"
  supports     [:start, :stop, :reload, :restart]
end
