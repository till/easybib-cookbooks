if is_aws
  Chef::Application.fatal!('This recipe is vagrant only')
end

include_recipe 'nginx-app::service'

node['vagrant']['applications'].each do |app_name, app_config|

  next if app_name == 'www'

  if app_config.attribute?('default_router')
    default_router = app_config['default_router']
  else
    default_router = 'index.php'
  end

  template = 'silex.conf.erb'

  template = 'scholar.conf.erb' if app_name == 'scholar'

  domain_name        = app_config['domain_name']
  doc_root_location  = app_config['doc_root_location']

  easybib_nginx app_name do
    config_template template
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    notifies :restart, 'service[nginx]', :delayed
  end

  stackname = 'easybib'

  if %w(scholar feature_flags).include?(app_name)
    stackname = 'scholar'
  end

  easybib_envconfig app_name do
    # we are using stackname easybib since both is served from www-vagrant
    stackname stackname
  end

end
