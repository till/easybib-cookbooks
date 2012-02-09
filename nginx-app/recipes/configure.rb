include_recipe "deploy"
include_recipe "nginx-app::server"

instanceRoles = node[:scalarium][:instance][:roles]

node[:deploy].each do |application, deploy|

  case application
  when 'easybib'
    if instanceRoles.include?('nginxphpapp')

    elsif instanceRoles.include?('testapp')

    else
      next
    end
  when 'easybib_api'
    next unless instanceRoles.include?('bibapi')
  when 'easybib_solr_research_importers'
    next # unless instanceRoles.include?('easybibsolr')
  when 'easybib_solr_server'
    next # unless instanceRoles.include?('easybibsolr')
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
