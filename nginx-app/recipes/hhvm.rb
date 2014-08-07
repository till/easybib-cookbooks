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

  easybib_nginx app_name do
    config_template "hhvm.conf.erb"
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    access_log 'off'
    nginx_extras node["nginx-app"]["extras"]
    notifies :restart, "service[nginx]", :delayed
  end
end
