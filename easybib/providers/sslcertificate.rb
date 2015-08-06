action :create do
  deploy = new_resource.deploy

  unless deploy.key?('ssl_certificate')
    Chef::Log.info("No ssl_certificate 'key'")
    next
  end

  unless deploy.key?('ssl_certificate_key')
    Chef::Log.info("No ssl_certificate_key 'key'")
    next
  end

  if deploy['ssl_certificate'].empty?
    Chef::Log.error('ssl_certificate is empty')
    next
  end

  if deploy['ssl_certificate_key'].empty?
    Chef::Log.error('ssl_certificate_key is empty')
    next
  end

  ssl_certificate_ca = ''

  if deploy.key?('ssl_certificate_ca')
    unless deploy['ssl_certificate_ca'].nil?
      ssl_certificate_ca = deploy['ssl_certificate_ca'].chomp
    end
  end

  ssl_dir    = node['ssl-deploy']['directory']
  ssl_certificate     = deploy['ssl_certificate'].chomp
  ssl_certificate_key = deploy['ssl_certificate_key'].chomp
  ssl_combined_key    = [ssl_certificate, ssl_certificate_key, ssl_certificate_ca].join("\n")

  d = directory ssl_dir do
    mode      '0750'
    owner     'root'
    group  node['nginx-app']['group']
    recursive true
  end

  t1 = template ssl_dir + '/cert.pem' do
    source 'ssl_key.erb'
    mode   '0640'
    owner  'root'
    group  node['nginx-app']['group']
    variables(
      'ssl_key' => ssl_certificate
    )
  end

  t2 = template ssl_dir + '/cert.key' do
    source 'ssl_key.erb'
    mode   '0640'
    owner  'root'
    group  node['nginx-app']['group']
    variables(
      'ssl_key' => ssl_certificate_key
    )
  end

  t3 = template ssl_dir + '/cert.combined.pem' do
    source 'ssl_key.erb'
    mode   '0640'
    owner  'root'
    group  node['nginx-app']['group']
    variables(
      'ssl_key' => ssl_combined_key
    )
  end

  new_resource.updated_by_last_action(d.updated_by_last_action? || t1.updated_by_last_action? || t2.updated_by_last_action? || t3.updated_by_last_action?)

end
