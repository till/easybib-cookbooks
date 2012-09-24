service "php-fpm" do
  service_name "php-fpm"
  supports     [:start, :status, :restart]
end
