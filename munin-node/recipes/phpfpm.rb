package "libwww-perl"

git "/opt/munin-phpfpm" do
  repository "git://github.com/lagged/PHP5-FPM-Munin-Plugins.git"
  reference "master"
  action :sync
end

phpfpm_plugins = ["phpfpm_average", "phpfpm_connections", "phpfpm_memory", "phpfpm_status", "phpfpm_processes" ]
phpfpm_plugins.each do |plugin|
  execute "fix permission" do
    command "chmod +x /opt/munin-phpfpm/#{plugin}"
  end
  link "/etc/munin/plugins/#{plugin}" do
    to "/opt/munin-phpfpm/#{plugin}"
  end
end

remote_file "/etc/munin/plugin-conf.d/phpfpm" do
  source "plugin.d-phpfpm"
  mode "0755"
  owner "root"
  group "root"
  backup false
  action :create
  notifies :restart, "service[munin-node]"
end

service "munin-node" do
  action :restart
end
