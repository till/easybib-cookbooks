package "strace"

easybib_site=node[:deploy][:easybib][:deploy_to]

cron_command = "/usr/bin/php #{easybib_site}/app/modules/impexport/bin/gearman_worker > #{node[:easybib_gearman][:log_file]}"

if node[:easybib_gearman][:debug] = true then
    cron_command = "/usr/bin/strace #{cron_command}"
end

file "#{node[:easybib_gearman][:log_file]}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/etc/logrotate.d/gearman-worker" do
  source "logrotate.erb"
  owner "root"
  group "root"
  mode "0644"
end

cron "Setup worker to run every 5 minutes" do
  minute "*/5"
  command cron_command
end
