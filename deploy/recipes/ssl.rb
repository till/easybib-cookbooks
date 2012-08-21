instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|
  Chef::Log.debug("deploy::ssl - app: #{application}, role: #{instance_roles}, clustername: #{cluster_name} -- debug2!")

  if instance_roles.to_s.chomp == 'lb' and cluster_name.to_s.chomp == 'EasyBib Playground'
    Chef::Log.debug("found it again! debug2!")
  end
end
