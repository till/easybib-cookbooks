# installs the monitrc for our backup process
include_recipe "monit::service"

template "/etc/monit/conf.d/citationbackup-redis.monitrc" do
  source "citationbackup.monit.erb"
  mode   "0644"
  owner  "root"
  group  "root"
  variables(
    'pid_file' => '/var/run/citation-backup/redis-importer.pid',
    'app_name' => 'citationbackup-redis',
    'group'    => 'www-data',
    'init'     => '/etc/init.d/redis-importer'
  )
  notifies :restart, "service[monit]"
end
