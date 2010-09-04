ebs_vol=node[:easybib_solr][:working_directory]

# node["solr"] is provided by scalarium

def till_run_svn(repository, destination, scm_data)
  svn_args="--non-interactive --no-auth-cache"
  svn_auth="--username #{scm_data["user"]} --password #{scm_data["password"]}"
  run "svn checkout #{svn_args} #{svn_auth} #{respository} #{destination}"
end

execute "Checkout: Research Importers" do
  repository  = "#{node["solr"]["deploy_svn"]}/research_importers/#{node["solr"]["research_version"]}/"
  destination = "#{ebs_vol}/research_importers"

  till_run_svn(repository, destination, node["deploy"]["easybib"]["scm"])
end

execute "Checkout: Solr" do
  repository  = "#{node["solr"]["deploy_svn"]}/solr/#{node["solr"]["solr_svn_version"]}"
  destination = "#{ebs_vol}/apache-solr-#{node["solr"]["solr_version"]}-compiled"

  till_run_svn(repository, destination, node["deploy"]["easybib"]["scm"])
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