{ "api" => "api.local", "discover" => "discover-api.local", "id" => "id.local" }.each do |app_name, app_domain_name|

  doc_root = "www"

  if app_name == "api"
    doc_root = "web"
  end

  domain_name = ''

  unless is_aws
    if node["vagrant"]["combined"] == true
      domain_name = app_domain_name
      deploy_dir = node["vagrant"]["deploy_to"][app_name]
    end
  end

  easybib_nginx app_name do
    config_template "silex.conf.erb"
    deploy_dir deploy_dir
    domain_name domain_name
    doc_root doc_root
    notifies :restart, "service[nginx]", :delayed
  end
end
