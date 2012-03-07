template "/etc/init/apache-solr.conf" do
  mode   "0644"
  source "upstart.erb"
  variables(
    :solr_install => "#{node[:apache_solr][:base_dir]}/apache-solr/#{node[:apache_solr][:app]}",
    :solr_version => node[:apache_solr][:version]
  )
end

service "apache-solr" do
  provider Chef::Provider::Service::Upstart
  action   :nothing
end
