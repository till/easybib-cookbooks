ebs_vol=node[:easybib_solr][:working_directory]

# The server is deployed and research app are deployed through deploy::easybib.

link "#{ebs_vol}/research_importers/etc/solr.conf" do
  to "/etc/solr.conf"
  not_if "test -h /etc/solr.conf"
end

link "#{ebs_vol}/research_importers/scripts/solr.sh" do
  to "/etc/init.d/solr"
  not_if "test -h /etc/init.d/solr"
end

link "#{node[:easybib_solr][:log_dir]}" do
  to "#{ebs_vol}/apache-solr-1.4-compiled/logs"
  ignore_failure true
end

remote_file "/etc/logrotate.d/solr" do
  source "solr.logrotate"
  mode "0644"
  owner "root"
  group "root"
end

service "solr" do
  service_name "solr"
  supports [:start, :status, :restart, :stop]
  action [ :enable, :start, :restart ]
end