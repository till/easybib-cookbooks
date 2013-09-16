if is_aws()
  deploy_dir = "/srv/www/domainadmin/current/build/"
  domain_name = node["gocourse"]["domain"]["domainadmin"]
else
  deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
  domain_name = ""
end

default_router = "index.html"
config = "domainadmin"

template "/etc/nginx/sites-enabled/#{config}.conf" do
  source "static.conf.erb"
  mode   "0755"
  owner  node["nginx-app"]["user"]
  group  node["nginx-app"]["group"]
  variables(
    :doc_root    => deploy_dir,
    :domain_name => domain_name,
    :access_log  => 'off',
    :nginx_extra => node["nginx-app"]["extras"],
    :default_router => default_router
  )
  notifies :restart, "service[nginx]", :delayed
end
