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
    next unless node[:scalarium][:instance][:roles].include?('bibapi')
  when 'easybib_solr_research_importers'
    next # unless node[:scalarium][:instance][:roles].include?('easybibsolr')
  when 'easybib_solr_server'
    next # unless node[:scalarium][:instance][:roles].include?('easybibsolr')
  when 'sitescraper'
    next unless instanceRoles.include?('sitescraper')
  else
    Chef::Log.debug("Skipping nginx configure for app #{application}");
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
