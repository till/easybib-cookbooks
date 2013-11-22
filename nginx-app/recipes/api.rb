easybib_nginx "api" do
  config_template "silex.conf.erb"
  doc_root 'web'
  notifies :restart, "service[nginx]", :delayed
end
