node['vagrant']['applications'].each do |app_name, app_data|
  easybib_nginx app_name do
    config_template 'silex.conf.erb'
    notifies :restart, 'service[nginx]', :delayed
  end

  easybib_envconfig app_name do
    stackname 'qa'
  end

end
