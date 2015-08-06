node['deploy'].each do |application, deploy|
  next unless allow_deploy(application, 'ssl', node['ssl-deploy']['ssl-role'])

  easybib_sslcertificate 'ssl' do
    deploy deploy
  end

end
