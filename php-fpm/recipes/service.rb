service_name = 'php-fpm'

service service_name do
  action :nothing
  service_name service_name
  supports [:start, :stop, :status, :reload, :restart]
end
