right_role = 'lb'
right_cluster = 'EasyBib Playground'
ssl_dir = '/tmp'

instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|
  Chef::Log.debug("deploy::ssl - app: #{application}, role: #{instance_roles}, clustername: #{cluster_name} -- debug6!")

  if instance_roles.to_s == right_role and cluster_name.to_s == right_cluster
    Chef::Log.debug("found it again! debug6!")

    if deploy.has_key?('ssl_certificate') and deploy.has_key?('ssl_certificate_key')
      ssl_certificate = deploy['ssl_certificate'].chomp
      ssl_certificate_key = deploy['ssl_certificate_key'].chomp
      Chef::Log.debug("debug6  cert=#{ssl_certificate}  certkey=#{ssl_certificate_key}")

      template ssl_dir + '/cert.pem' do
        source 'ssl_key.erb'
        mode   '0644'
        owner  'root'
        group  'root'
        variables(
          'ssl_key' => ssl_certificate
        )
      end

      template ssl_dir + '/cert.key' do
        source 'ssl_key.erb'
        mode   '0644'
        owner  'root'
        group  'root'
        variables(
          'ssl_key' => ssl_certificate_key
        )
      end
    else
      Chef::Log.debug("debug6  don't have any keys stored here")
    end
  end
end
