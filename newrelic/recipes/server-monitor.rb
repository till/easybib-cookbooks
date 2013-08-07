include_recipe "newrelic::service"

execute "newrelic-license" do
  command "nrsysmond-config --set license_key=#{node["newrelic"]["license"]}"
  action :nothing
  notifies :create, "template[/etc/newrelic/nrsysmond.cfg]", :immediately
end

host_name = "#{node["hostname"]}.#{get_cluster_name().gsub(/\s+/, "-").strip.downcase}"

template "/etc/newrelic/nrsysmond.cfg" do
  source "nrsysmond.cfg.erb"
  owner "root"
  group "newrelic"
  mode "0640"
  variables({
    :license_key => node["newrelic"]["license"],
    :logfile => node["newrelic"]["sysmond"]["log"]["file"],
    :loglevel => node["newrelic"]["sysmond"]["log"]["level"],
    :hostname => host_name
  })
  action :nothing
  notifies :start, "service[newrelic-sysmond]", :immediately
end

package "newrelic-sysmond" do
  notifies :run, "execute[newrelic-license]", :immediately
end
