include_recipe 'nginx-app::server'

instance_roles   = get_instance_roles
cluster_name     = get_cluster_name
app_access_log   = node['nginx-app']['access_log']
nginx_config_dir = node['nginx-app']['config_dir']

# need to do this better
if !node.attribute?('docroot') || node['docroot'].empty?
  node.set['docroot'] = 'www'
end

# password protect?
password_protected = false

nginx_config = node['nginx-app']['conf_file']

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

  when 'infolit'
    next unless allow_deploy(application, 'infolit', 'nginxphpapp')
    nginx_config = 'infolit.conf.erb'

  when 'sitescraper'
    next unless allow_deploy(application, 'sitescraper')

  when 'research_app'
    next unless allow_deploy(application, 'research_app', 'research_app')

  else
    Chef::Log.info("Skipping nginx-app::configure for app #{application}")
    next
  end

  php_upstream = "unix:/var/run/php-fpm/#{node['php-fpm']['user']}"

  template "render vhost: #{application}" do
    path   "#{nginx_config_dir}/sites-enabled/easybib.com.conf"
    source nginx_config
    mode   '0755'
    owner  node['nginx-app']['user']
    group  node['nginx-app']['group']
    variables(
      :js_alias           => node['nginx-app']['js_modules'],
      :img_alias          => node['nginx-app']['img_modules'],
      :css_alias          => node['nginx-app']['css_modules'],
      :access_log         => app_access_log,
      :deploy             => deploy,
      :password_protected => password_protected,
      :config_dir         => nginx_config_dir,
      :php_upstream       => php_upstream
    )
    notifies :restart, 'service[nginx]', :delayed
  end

  easybib_envconfig application

end
