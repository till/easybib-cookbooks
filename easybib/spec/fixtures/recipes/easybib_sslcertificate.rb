include_recipe 'haproxy::service'

easybib_sslcertificate 'something' do
  deploy node['fake_deploy']
  notifies :reload, 'service[haproxy]', :immediately
end
