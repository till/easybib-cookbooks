easybib_nginx "bibcd" do
  config_template "silex.conf.erb"
  doc_root 'web'
  notifies :restart, "service[nginx]", :delayed
end
