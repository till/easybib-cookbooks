include_recipe 'haproxy::service'

node['deploy'].each do |application, deploy|
  next unless allow_deploy(application, 'ssl', node['ssl-deploy']['ssl-role'])

  easybib_sslcertificate 'ssl' do
    deploy deploy
    notifies :reload, 'service[haproxy]', :delayed
  end
end
