include_recipe "deploy"
include_recipe "nginx-app::server"

instance_roles = node[:scalarium][:instance][:roles]

node[:deploy].each do |application, deploy|

  case application
  when 'easybib'
    if !instance_roles.include?('nginxphpapp') && !instance_roles.include?('testapp')
      next
    end

  when 'easybib_api'
    next unless instance_roles.include?('bibapi')

  when 'sitescraper'
    next unless instance_roles.include?('sitescraper')

  when 'admedia'
    next unless instance_roles.include?('admedia')

  else
    Chef::Log.debug("Skipping nginx-app::configure for app #{application}")
    next
  end

  template "/etc/nginx/sites-enabled/easybib.com.conf" do
    source "easybib.com.conf.erb"
    mode "0755"
    owner node["nginx-app"][:user]
    group node["nginx-app"][:group]
    variables :deploy => deploy, :application => application
    notifies :restart, resources(:service => "nginx"), :delayed
  end

end

service "php-fpm" do
  service_name "php-fpm"
  supports [ :start, :status, :restart ]
  action :restart
end
