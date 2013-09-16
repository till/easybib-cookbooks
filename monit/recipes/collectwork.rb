# installs the monitrc for our collectwork processes
include_recipe "monit::service"

thepidfile=node["monit"]["collectwork"]["pid_file"]
thepiddir=node["monit"]["collectwork"]["pid_dir"]
thename=node["monit"]["collectwork"]["name"]
thestartscript=node["monit"]["collectwork"]["start_script"]
thehelperscript=node["monit"]["collectwork"]["helper_script"]
theuser=node["monit"]["collectwork"]["user"]
thecmd=node["monit"]["collectwork"]["command"]

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
  notifies :restart, "service[monit]"
end
