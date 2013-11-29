["bibcd", "bib-opsstatus"].each do |app_name|
  easybib_nginx app_name do
    config_template "silex.conf.erb"
    notifies :restart, "service[nginx]", :delayed
  end
end
