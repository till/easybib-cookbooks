# installs start script for gearman-manager

daemon       = node["gearmanmanager"]["daemon"]
real_daemon  = node["gearmanmanager"]["real_daemon"]
pid_dir      = node["gearmanmanager"]["pid_dir"]
config_file  = node["gearmanmanager"]["config_file"]
worker_class = node["gearmanmanager"]["worker_class"]

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

service "gearman-manager" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
