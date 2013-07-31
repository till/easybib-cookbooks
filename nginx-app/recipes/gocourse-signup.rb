if is_aws()
  deploy_dir = "/srv/www/signup/current/src/"
  nginx_extras = ""
  domain_name = node["gocourse"]["domain"]["signup"]
else
  deploy_dir = "/vagrant_data/src/"
  domain_name = ""
  nginx_extras = "sendfile off;"
end

default_router = "index.html"
config = "signup"

template "/etc/nginx/sites-enabled/#{config}.conf" do
  source "static.conf.erb"
  mode   "0755"
  owner  node["nginx-app"][:user]
  group  node["nginx-app"][:group]
  variables(
    :doc_root    => deploy_dir,
    :domain_name => domain_name,
    :access_log  => 'off',
    :nginx_extra => nginx_extras,
    :default_router => default_router
  )
  notifies :restart, resources(:service => "nginx"), :delayed
end
