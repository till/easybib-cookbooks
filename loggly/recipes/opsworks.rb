roles = get_instance_roles()

service "rsyslog" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end
