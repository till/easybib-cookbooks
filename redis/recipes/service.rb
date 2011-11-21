service "redis-server" do
  service_name "redis-server"

  supports :status => false, :restart => true, :reload => false, "force-reload" => true
  action :enable
end
