# php_fpm plugins
# clone from github

git "/opt/munin-phpfpm" do
  repository "git://github.com/bummercloud/PHP5-FPM-Munin-Plugins.git"
  reference "39b38262ac0bbdaae9a82fc415518491acb115ea"
  action :sync
end

phpfpm_plugins = ["phpfpm_average", "phpfpm_connections", "phpfpm_memory", "phpfpm_status", "phpfpm_processes" ]
phpfpm_plugins.each do |plugin|
  link "/etc/munin/plugins/#{plugin}" do
    to "/opt/munin-phpfpm/#{plugin}"
  end
end

# symlink

