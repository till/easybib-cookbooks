include_recipe 'haproxy::service'

node['deploy'].each do |application, deploy|
  next unless allow_deploy(application, 'ssl', node['ssl-deploy']['ssl-role'])

  easybib_sslcertificate 'ssl' do
    deploy deploy
    Chef::Log.info("******* NOTIFY HAPROXY FOR RELOAD ********")
    notifies :reload, 'service[haproxy]', :delayed
  end
end
