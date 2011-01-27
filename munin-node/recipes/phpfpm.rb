package "libwww-perl"

git "/opt/munin-phpfpm" do
  repository "git://github.com/bummercloud/PHP5-FPM-Munin-Plugins.git"
  reference "master"
  action :sync
end

phpfpm_plugins = ["phpfpm_average", "phpfpm_connections", "phpfpm_memory", "phpfpm_status", "phpfpm_processes" ]
phpfpm_plugins.each do |plugin|
  link "/etc/munin/plugins/#{plugin}" do
    to "/opt/munin-phpfpm/#{plugin}"
  end
end
