if is_aws
  Chef::Application.fatal!('This recipe is vagrant only')
end

node["vagrant"]["applications"].each do |app_name, app_config|

  domain_name    = app_config["domain_name"]
  doc_root_location  = app_config["doc_root_location"]

  easybib_nginx app_name do
    config_template "silex.conf.erb"
    deploy_dir doc_root_location
    domain_name domain_name
    notifies :restart, "service[nginx]", :delayed
  end
end
