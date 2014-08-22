config = "management"

if is_aws
  deploy_dir = "/srv/www/#{config}/current/dist/"
else
  if node["vagrant"]["combined"] == true
    if node.fetch("vagrant", {}).fetch("applications", {}).fetch(config, {})["doc_root_location"].nil?
      Chef::Log.warn("Please upgrade getcourse/vagrant, your web_dna.json is outdated!")
      deploy_dir = node["vagrant"]["deploy_to"][config]
    else
      deploy_dir = node["vagrant"]["applications"][config]["doc_root_location"]
    end
  else
    deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
  end
end

domain_name = ::EasyBib::Config.get_domains(node, config, 'getcourse')
default_router = "index.html"

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

easybib_envconfig config
