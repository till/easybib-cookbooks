easybib_nginx "bib-opsstatus" do
  config_template "silex.conf.erb"
  doc_root "web"
  notifies :restart, "service[nginx]", :delayed
end
