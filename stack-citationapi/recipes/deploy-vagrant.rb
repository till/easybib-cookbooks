get_apps_to_deploy.each do |app_name, app_config|
  next unless %w(sitescraper pdf-autocite formatting-api citation-apis).include?(app_name)

  default_router = if app_config.attribute?('default_router')
                     app_config['default_router']
                   else
                     'index.php'
                   end

  template = 'default-web-nginx.conf.erb'

  domain_name        = ::EasyBib::Config.get_appdata(node, app_name, 'domains')
  doc_root_location  = ::EasyBib::Config.get_appdata(node, app_name, 'doc_root_dir')
  app_dir            = ::EasyBib::Config.get_appdata(node, app_name, 'app_dir')

  easybib_nginx app_name do
    cookbook 'stack-citationapi'
    config_template template
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    notifies :reload, 'service[nginx]', :delayed
  end

  easybib_envconfig app_name

  easybib_supervisor "#{app_name}_supervisor" do
    supervisor_file "#{app_dir}/deploy/supervisor.json"
    app_dir app_dir
    app app_name
    user node['php-fpm']['user']
  end

  easybib_gearmanw app_dir

end
