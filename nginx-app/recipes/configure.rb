include_recipe 'nginx-app::server'

app_access_log   = node['nginx-app']['access_log']
nginx_config_dir = node['nginx-app']['config_dir']

# password protect?
password_protected = false

nginx_config = node['nginx-app']['conf_file']
config_name = 'easybib.com.conf'

node['deploy'].each do |application, deploy|
  Chef::Log.info("nginx-app::configure - app: #{application}")

  case application
  when 'easybib'
    nginxphpapp_allowed = allow_deploy(application, 'easybib', 'nginxphpapp')
    testapp_allowed     = allow_deploy(application, 'easybib', 'testapp')
    if !nginxphpapp_allowed && !testapp_allowed
      Chef::Log.info('nginx-app::configure - skipping easybib, allow_deploy mismatch')
      next
    end

  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'bibapi')

  when 'research_app'
    next unless allow_deploy(application, 'research_app', 'research_app')

  else
    Chef::Log.info("Skipping nginx-app::configure for app #{application}")
    next
  end

  env_conf = ::EasyBib::Config.get_env('nginx', application, node)
  configured_domains = ::EasyBib::Config.get_domains(node, application, env_conf)
  Chef::Log.info("nginx-app::configure - domains: #{configured_domains}")

  template "render vhost: #{application}" do
    path   "#{nginx_config_dir}/sites-enabled/#{config_name}"
    source nginx_config
    mode   '0755'
    owner  node['nginx-app']['user']
    group  node['nginx-app']['group']
    helpers EasyBib::Helpers
    variables(
      :domain_name        => configured_domains,
      :js_alias           => node['nginx-app']['js_modules'],
      :img_alias          => node['nginx-app']['img_modules'],
      :css_alias          => node['nginx-app']['css_modules'],
      :access_log         => app_access_log,
      :deploy             => deploy,
      :password_protected => password_protected,
      :config_dir         => nginx_config_dir,
      :php_upstream       => get_upstream_from_pools(node['php-fpm']['pools'], node['php-fpm']['socketdir']),
      :upstream_name      => application,
      :environment        => ::EasyBib.get_cluster_name(node),
      :doc_root           => ::EasyBib::Config.get_appdata(node, application, 'doc_root_dir'),
      :app_dir            => ::EasyBib::Config.get_appdata(node, application, 'app_dir')
    )
    notifies :run, 'execute[configtest]', :immediately
    notifies :reload, 'service[nginx]', :delayed
  end

  easybib_envconfig application do
    stackname 'easybib'
  end
end
