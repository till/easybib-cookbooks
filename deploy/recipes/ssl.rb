instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|
  Chef::Log.debug("deploy::ssl - app: #{application}, role: #{instance_roles}, clustername: #{cluster_name} -- debug4!")

  if instance_roles.to_s == 'lb' and cluster_name.to_s == 'EasyBib Playground'
    Chef::Log.debug("found it again! debug4!")

    if deploy.has_key?('ssl_certificate') and deploy.has_key?('ssl_certificate_key')
      ssl_certificate = deploy['ssl_certificate']
      ssl_certificate_key = deploy['ssl_certificate_key']
      Chef::Log.debug("debug4  cert=#{ssl_certificate}  certkey=#{ssl_certificate_key}")
    else
      Chef::Log.debug("debug4  don't have any keys stored here")
    end
  end
end
