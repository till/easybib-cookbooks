["bibcd", "bib-opsstatus"].each do |app_name|
  easybib_nginx app_name do
    config_template "silex.conf.erb"
    env_source app_name
    notifies :restart, "service[nginx]", :delayed
  end
end
