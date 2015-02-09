include_recipe 'nginx-app::service'
nginx_dir     = node['nginx-app']['config_dir']
ssl_dir       = node['ssl-deploy']['directory']
int_ip        = '127.0.0.1'

unless node.fetch('vagrant', {})['ssl'].nil?
  deploy = node['vagrant']['ssl']
  ssl_certificate     = deploy['ssl_certificate'].chomp
  ssl_certificate_key = deploy['ssl_certificate_key'].chomp

  directory ssl_dir do
    mode      '0750'
    owner     'root'
    group  node['nginx-app']['group']
    recursive true
  end

  template ssl_dir + '/cert.pem' do
    source 'ssl_key.erb'
    mode   '0640'
    owner  'root'
    group  node['nginx-app']['group']
    variables(
      'ssl_key' => ssl_certificate
    )
    notifies :restart, 'service[nginx]'
  end

  template ssl_dir + '/cert.key' do
    source 'ssl_key.erb'
    mode   '0640'
    owner  'root'
    group  node['nginx-app']['group']
    variables(
      'ssl_key' => ssl_certificate_key
    )
    notifies :restart, 'service[nginx]'
  end

  template nginx_dir + '/sites-enabled/easybib-ssl.conf' do
    source 'nginx-ssl.conf.erb'
    mode   '0644'
    owner  'root'
    group  'root'
    variables(
      'ssl_dir' => ssl_dir,
      'int_ip'  => int_ip
    )
    notifies :restart, 'service[nginx]'
  end
end
