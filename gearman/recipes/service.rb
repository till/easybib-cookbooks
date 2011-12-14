service "gearman-job-server" do
  service_name "gearman-job-server"

  supports :status => false, :restart => true, :reload => false, "force-reload" => true
  action :enable
end
