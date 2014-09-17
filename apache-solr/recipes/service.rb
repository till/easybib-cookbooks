template "/etc/init/apache-solr.conf" do
  mode   "0644"
  source "upstart.erb"
  variables(
    :solr_data_dir => node["apache_solr"]["data_dir"],
    :solr_install => "#{node["apache_solr"]["base_dir"]}/solr/",
    :solr_version => node["apache_solr"]["version"],
    :solr_mem_max => node["apache_solr"]["memory"]["max"],
    :solr_mem_min => node["apache_solr"]["memory"]["min"],
    :solr_log     => node["apache_solr"]["log_file"]
  )
end

service "apache-solr" do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :stop => true, :restart => true
  action   :enable
end
