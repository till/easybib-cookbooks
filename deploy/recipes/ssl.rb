instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|

  Chef::Log.debug("deploy::ssl - app: #{application}, role: #{instance_roles}")

  case application
  when 'lb'
    if cluster_name != 'EasyBib Playground'
      next
    end
    Chef::Log.debug("found it!")
  end

end
