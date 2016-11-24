Chef::Application.fatal!('This recipe is vagrant only') if is_aws

include_recipe 'nginx-app::service'

node['vagrant']['applications'].each do |app_name, app_config|

  next if app_name == 'www'

  default_router = if app_config.attribute?('default_router')
                     app_config['default_router']
                   else
                     'index.php'
                   end

  template = 'silex.conf.erb'

  domain_name = app_config['domain_name']

  app_dir = app_config['app_root_location']

  easybib_nginx app_name do
    config_template template
    default_router default_router
    domain_name domain_name
    notifies :reload, 'service[nginx]', :delayed
  end

  easybib_envconfig app_name do
    # we are using stackname easybib since both is served from www-vagrant
    stackname 'easybib'
  end

  next if app_name == 'edu'
  easybib_supervisor app_name do
    supervisor_file "#{app_dir}/deploy/supervisor.json"
    app_dir app_dir
    user node['php-fpm']['user']
  end
end
