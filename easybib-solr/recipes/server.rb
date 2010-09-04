ebs_vol=node[:easybib_solr][:working_directory]

# node["solr"] is provided by scalarium

subversion "Checkout: Research Importers" do
  repository "#{node["solr"]["deploy_svn"]}/research_importers/#{node["solr"]["research_version"]}/"
  destination "#{ebs_vol}/research_importers"
  svn_username node["deploy"]["easybib"]["scm"]["user"]
  svn_password node["deploy"]["easybib"]["scm"]["password"]
  svn_arguments "--no-auth-cache"
  action :sync
end

subversion "Checkout: Solr" do
  repository "#{node["solr"]["deploy_svn"]}/solr/#{node["solr"]["solr_svn_version"]}"
  destination "#{ebs_vol}/apache-solr-#{node["solr"]["solr_version"]}-compiled"
  svn_username node["deploy"]["easybib"]["scm"]["user"]
  svn_password node["deploy"]["easybib"]["scm"]["password"]
  svn_arguments "--no-auth-cache"
  action :sync
end

link "#{ebs_vol}/research_importers/etc/solr.conf" do
  to "/etc/solr.conf"
  not_if "test -h /etc/solr.conf"
end

link "#{ebs_vol}/research_importers/scripts/solr.sh" do
  to "/etc/init.d/solr"
  not_if "test -h /etc/init.d/solr"
end

link "#{node[:easybib_solr][:log_dir]}" do
  to "#{ebs_vol}/apache-solr-#{node["solr"]["solr_version"]}-compiled/logs"
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
  action [ :enable, :start ]
end