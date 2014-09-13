remote_file "/etc/nginx/sites-available/tsung" do
  source "tsung.host"
  mode "0644"
  owner "www-data"
  group "www-data"
  action :create
  notifies "service[nginx]", :enable, :immediately
  notifies "service[nginx]", :restart, :delayed
end
