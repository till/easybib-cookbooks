{ "api" => "web", "discover_api" => "www" }.each do |app_name, document_root|
  easybib_nginx app_name do
    config_template "silex.conf.erb"
    doc_root document_root
    notifies :restart, "service[nginx]", :delayed
  end
end
