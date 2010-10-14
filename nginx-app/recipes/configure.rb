include_recipe "deploy"
include_recipe "nginx-app::server"

node[:deploy].each do |application, deploy|

  case application
  when 'easybib'
    next unless node[:scalarium][:instance][:roles].include?('nginxphpapp')
  when 'easybib_api'
    next unless node[:scalarium][:instance][:roles].include?('bibapi')
  when 'easybib_solr_research_importers'
    next unless node[:scalarium][:instance][:roles].include?('easybibsolr')
  when 'easybib_solr_server'
    next unless node[:scalarium][:instance][:roles].include?('easybibsolr')
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
