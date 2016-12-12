use_inline_resources

action :create do
  deploy = new_resource.deploy

  missing = false

  %w(ssl_certificate ssl_certificate_key).each do |test_key|
    unless deploy.key?(test_key)
      Chef::Log.info("Missing key: #{test_key}")
      missing = true
      next
    end

    next unless deploy[test_key].empty?

    Chef::Log.info("Data for '#{test_key}' is empty")
    missing = true
  end

  next if missing == true

  ssl_certificate_ca = ''

  if deploy.key?('ssl_certificate_ca')
    unless deploy['ssl_certificate_ca'].nil?
      ssl_certificate_ca = deploy['ssl_certificate_ca'].chomp
    end
  end

  ssl_dir             = node['ssl-deploy']['directory']
  ssl_certificate     = get_actual(deploy['ssl_certificate'])
  ssl_certificate_key = get_actual(deploy['ssl_certificate_key'])
  ssl_combined_key    = [ssl_certificate, ssl_certificate_key, ssl_certificate_ca].join("\n")

  d = directory ssl_dir do
    mode      '0750'
    owner     'root'
    group     node['nginx-app']['group']
    recursive true
  end

  t1 = template ssl_dir + '/cert.pem' do
    source 'empty.erb'
    cookbook 'easybib'
    mode   '0640'
    owner  'root'
    group  node['nginx-app']['group']
    variables(
      'content' => ssl_certificate
    )
  end

  t2 = template ssl_dir + '/cert.key' do
    source 'empty.erb'
    cookbook 'easybib'
    mode   '0640'
    owner  'root'
    group  node['nginx-app']['group']
    variables(
      'content' => ssl_certificate_key
    )
  end

  t3 = template ssl_dir + '/cert.combined.pem' do
    source 'empty.erb'
    cookbook 'easybib'
    mode   '0640'
    owner  'root'
    group  node['nginx-app']['group']
    variables(
      'content' => ssl_combined_key
    )
  end

  new_resource.updated_by_last_action(true) if d.updated_by_last_action?
  new_resource.updated_by_last_action(true) if t1.updated_by_last_action?
  new_resource.updated_by_last_action(true) if t2.updated_by_last_action?
  new_resource.updated_by_last_action(true) if t3.updated_by_last_action?

end

def get_actual(str)
  return str.chomp if str.include?('-----BEGIN')

  ::File.read(str)
end
