if is_aws
  Chef::Application.fatal!('This recipe is vagrant only')
end

node["vagrant"]["applications"].each do |app_name, app_config|

  next if app_name == "www"

  if app_config.attribute?("default_router")
    default_router = app_config["default_router"]
  else
    default_router = "index.php"
  end

  domain_name        = app_config["domain_name"]
  doc_root_location  = app_config["doc_root_location"]

  if app_config["app_root_location"]
    app_root_location = app_config["app_root_location"]
  else
    Chef::Log.warn('app_root_location is not set in web_dna.json, trying to guess')
    app_root_location = "/" + doc_root_location.split('/')[1..-2].join('/')
  end

  easybib_nginx app_name do
    config_template "silex.conf.erb"
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    notifies :restart, "service[nginx]", :delayed
  end

  easybib_envconfig app_name do
    path app_root_location
  end

end
