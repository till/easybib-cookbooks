instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|
  Chef::Log.debug("deploy::ssl - app: #{application}, role: #{instance_roles}, clustername: #{cluster_name} -- debug3!")

  if instance_roles.to_s == 'lb' and cluster_name.to_s == 'EasyBib Playground'
    Chef::Log.debug("found it again! debug3!")

    application.each do |appkey,appval|
      Chef::Log.debug("application  #{appkey} = #{appval}")
    end

    deploy.each do |depkey,depval|
      Chef::Log.debug("deploy  #{depkey} = #{depval}")
    end
  end
end
