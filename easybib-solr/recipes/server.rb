ebs_vol=node[:easybib_solr][:working_directory]

# The server is deployed and research app are deployed through deploy::easybib.

if File.exists?("#{ebs_vol}/research_importers/current/etc/solr.conf")

  link "/etc/solr.conf" do
    to "#{ebs_vol}/research_importers/current/etc/solr.conf"
    not_if "test -h /etc/solr.conf"
  end

  link "/etc/init.d/solr" do
    to "#{ebs_vol}/research_importers/current/scripts/solr.sh"
    not_if "test -h /etc/init.d/solr"
  end

else

  Chef::Log.debug('Skip symlinking solr.conf and start script because research_importers needs to be deployed first.')

end

link "#{ebs_vol}/apache-solr-1.4-compiled/current/logs" do
  to "#{node[:easybib_solr][:log_dir]}"
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
  action [ :enable ]
  only_if "test -h /etc/init.d/solr"
end