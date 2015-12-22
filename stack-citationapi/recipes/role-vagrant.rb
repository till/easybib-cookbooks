if is_aws
  Chef::Application.fatal!('This recipe is vagrant only')
end

include_recipe 'stack-easybib::role-phpapp'
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

  app_dir = app_config['app_root_location']

  easybib_nginx app_name do
    config_template template
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    nginx_local_conf "#{app_dir}/deploy/nginx.conf"
    notifies :reload, 'service[nginx]', :delayed
  end
end
