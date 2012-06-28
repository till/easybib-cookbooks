# installs the monitrc for our collectwork processes
include_recipe "monit::service"

template "/etc/init.d/collectwork" do
  source "collectwork.init.erb"
  mode   "0755"
  owner  "root"
  group  "root"
  variables(
    'pid_file' => '/var/run/collectwork/collectwork.pid',
    'pid_dir'  => '/var/run/collectwork',
    'app_name' => 'collectwork',
    'daemon'   => '/usr/local/bin/collectwork',
    'the_user' => 'www-data'
  )
end

template "/usr/local/bin/collectwork" do
  source "collectwork.php.erb"
  mode   "0755"
  owner  "root"
  group  "root"
  variables(
    'pid_file' => '/var/run/collectwork/collectwork.pid',
    'cmd'      => '/srv/www/ebim2/current/bin/ebim2 cron-collect-work',
    'name'     => 'collectwork'
  )
end

template "/etc/monit/conf.d/collectwork.monitrc" do
  source "collectwork.monit.erb"
  mode   "0644"
  owner  "root"
  group  "root"
  variables(
    'app_name' => 'collectwork',
    'init'     => '/etc/init.d/collectwork',
    'pid_file' => '/var/run/collectwork/collectwork.pid'
  )
  notifies :restart, resources(:service => "monit")
end
