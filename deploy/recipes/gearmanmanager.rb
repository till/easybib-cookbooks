# installs start script for gearman-manager

daemon = node["deploy"]["gearmanmanager"]["daemon"]
real_daemon = node["deploy"]["gearmanmanager"]["real_daemon"]
pid_dir = node["deploy"]["gearmanmanager"]["pid_dir"]
config_file = node["deploy"]["gearmanmanager"]["config_file"]
worker_class = node["deploy"]["gearmanmanager"]["worker_class"]

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
