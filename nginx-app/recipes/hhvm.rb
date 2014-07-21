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

  env_conf = ""
  if has_env?(app_name)
    env_conf = get_env_for_nginx(app_name)
  end

  easybib_nginx app_name do
    config_template "hhvm.conf.erb"
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    env_config env_conf
    notifies :restart, "service[nginx]", :delayed
  end
end
