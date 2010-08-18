include_recipe "nginx-app::server"

node[:deploy].each do |application, deploy|
  template "/etc/nginx/sites-available/easybib.com.conf" do
    source "easybib.com.conf.erb"
    mode "0755"
    owner node["nginx-app"][:user]
    group node["nginx-app"][:group]
    variables :deploy => deploy, :application => application
    notifies :restart, resources(:service => "nginx"), :delayed
  end
end
