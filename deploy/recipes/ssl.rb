right_role = node[:deploy][:ssl][:role]
right_cluster = node[:deploy][:ssl][:cluster]
ssl_dir = node[:deploy][:ssl][:dir]

instance_roles = node[:scalarium][:instance][:roles]
cluster_name = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|
  if instance_roles.to_s == right_role and cluster_name.to_s == right_cluster and deploy.has_key?('ssl_certificate') and deploy.has_key?('ssl_certificate_key')
    ssl_certificate = deploy['ssl_certificate'].chomp
    ssl_certificate_key = deploy['ssl_certificate_key'].chomp

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
  end
end
