easybib_nginx "bib-opsstatus" do
  config_template "silex.conf.erb"
  doc_root "web"
  env_source "bib-opsstatus"
  notifies :restart, "service[nginx]", :delayed
end
