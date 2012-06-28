# installs the monitrc for our collectwork processes
include_recipe "monit::service"

# configure me
thepidfile="/var/run/collectwork/collectwork.pid"
thepiddir="/var/run/collectwork"
thename="collectwork"
thestartscript="/etc/init.d/collectwork"
thehelperscript="/usr/local/bin/collectwork"
theuser="www-data"
thecmd="/srv/www/ebim2/current/bin/ebim2 cron-collect-work"

template thestartscript do
  source "collectwork.init.erb"
  mode   "0755"
  owner  "root"
  group  "root"
  variables(
    'pid_file' => thepidfile,
    'pid_dir'  => thepiddir,
    'app_name' => thename,
    'daemon'   => thehelperscript,
    'the_user' => theuser
  )
end

template thehelperscript do
  source "collectwork.php.erb"
  mode   "0755"
  owner  "root"
  group  "root"
  variables(
    'pid_file' => thepidfile,
    'cmd'      => thecmd,
    'name'     => thename
  )
end

template "/etc/monit/conf.d/collectwork.monitrc" do
  source "collectwork.monit.erb"
  mode   "0644"
  owner  "root"
  group  "root"
  variables(
    'app_name' => thename,
    'init'     => thestartscript,
    'pid_file' => thepidfile
  )
  notifies :restart, resources(:service => "monit")
end
