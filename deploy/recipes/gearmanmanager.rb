# installs start script for gearman-manager

# configure me
daemon="/usr/local/bin/gearman-manager"
real_daemon="/srv/www/ebim2/current/vendor/GearmanManager/pecl-manager.php"
pid_dir="/var/run/gearman-manager"
config_file="/srv/www/ebim2/releases/20120502171407/etc/gearman/jango-fett.manager.ini"
worker_class="Ebim2\\Gearman\\Worker\\"

link daemon do
  to real_daemon
end

template "/etc/init.d/gearman-manager" do
  source "gearman-manager.init.erb"
  mode   "0755"
  owner  "root"
  group  "root"
  variables(
    'daemon'       => daemon,
    'pid_dir'      => pid_dir,
    'config_file'  => config_file,
    'worker_class' => worker_class
  )
end
