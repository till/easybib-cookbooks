include_recipe "newrelic::service"

execute "newrelic-license" do
  command "nrsysmond-config --set license_key=#{node["newrelic"]["license"]}"
  action :nothing
  notifies :create, "template[/etc/newrelic/nrsysmond.easybib.cfg]", :immediately
  not_if do
    node["newrelic"]["license"].empty?
  end
end

package "newrelic-sysmond" do
  action :install
  notifies :run, "execute[newrelic-license]", :immediately
  not_if do
    node["newrelic"]["license"].empty?
  end
end

template "/etc/default/newrelic-sysmond" do
  source "nrsysmond.default.erb"
  owner "root"
  group "newrelic"
  mode "0640"
end

host_name = "#{node["hostname"]}.#{get_cluster_name.gsub(/\s+/, "-").strip.downcase}"

template "/etc/newrelic/nrsysmond.easybib.cfg" do
  source "nrsysmond.cfg.erb"
  owner "root"
  group "newrelic"
  mode "0640"
  variables(
    :license_key => node["newrelic"]["license"],
    :logfile => node["newrelic"]["sysmond"]["log"]["file"],
    :loglevel => node["newrelic"]["sysmond"]["log"]["level"],
    :hostname => host_name
  )
  action :create
  notifies :restart, "service[newrelic-sysmond]", :immediately
  not_if do
    node["newrelic"]["license"].empty?
  end
end
