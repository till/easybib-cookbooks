if !deploy
  raise "This recipe has to run from a deployment cycle."
end

if !deploy[:deploy_to]
  raise "Could not find directory where application is deployed to."
end

base_dir = deploy[:deploy_to]
app_dir  = "#{base_dir}/vendor/GearmanManager"
etc_dir  = "#{base_dir}/etc/gearman"

link "/usr/local/bin/gearman-manager" do
  to "#{app_dir}/#{node[:gearman-manager][:type]}-manager.php"
end

link "/etc/gearman-manager" do
  to etc_dir
end

link "/etc/init.d/gearman-manager" do
  to "#{base_dir}/bin/gearman-manager.initd"
end
