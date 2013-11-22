are_we_there_yet = is_aws()

easybib_nginx "api" do
  config_template "silex.conf.erb"
  aws are_we_there_yet
  doc_root 'web'
  notifies :restart, "service[nginx]", :delayed
end
