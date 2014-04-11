include_recipe "monit::default"
include_recipe "monit::service"

template "/etc/monit/conf.d/pecl-manager.monitrc" do
  source "gearmand.monit.erb"
  mode   "0644"
  owner  "root"
  group  "root"
  variables(
    'pid_file' => '/var/run/gearman/manager.pid',
    'app_name' => 'pecl-manager',
    'group'    => 'gearman',
    'init'     => '/etc/init.d/pecl-manager'
  )
  notifies :restart, "service[monit]"
end
