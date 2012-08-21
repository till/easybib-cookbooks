instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|
  Chef::Log.debug("deploy::ssl - app: #{application}, role: #{instance_roles}, clustername: #{cluster_name}")

  if instance_roles == 'lb' and cluster_name == 'EasyBib Playground'
    Chef::Log.debug("found it again!")
  end
end
