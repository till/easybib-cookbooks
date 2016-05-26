action :remove do
  config_name = get_config_name(new_resource)
  file "/etc/nginx/sites-enabled/#{config_name}.conf" do
    action :delete
    only_if do
      File.exist?("/etc/nginx/sites-enabled/#{config_name}.conf")
    end
  end
  file "/etc/nginx/#{config_name}.htpasswd" do
    action :delete
    only_if do
      File.exist?("/etc/nginx/#{config_name}.htpasswd")
    end
  end
  new_resource.updated_by_last_action(true)
end

action :setup do
  config_template = new_resource.config_template
  access_log = new_resource.access_log
  application = new_resource.app_name
  listen_opts = new_resource.listen_opts
  cookbook = new_resource.cookbook

  domain_name = get_domain_name(new_resource, node)
  deploy_dir = get_deploy_dir(new_resource, node)
  app_dir = get_app_dir(new_resource, node)
  config_name = get_config_name(new_resource)
  nginx_extras = get_nginx_extras(new_resource, node)
  cache_config = get_cache_config(new_resource, node)

  htpasswd = get_htpasswd(new_resource, application)

  health_check = get_health_check(application, node)
  routes_enabled =  get_routes(application, node, 'routes_enabled')
  routes_denied  =  get_routes(application, node, 'routes_denied')

  default_router = get_default_router(node['nginx-app']['default_router'], new_resource.default_router, deploy_dir)

  nginx_local_conf = get_local_conf("#{app_dir}/deploy/nginx.conf")

  execute_name = "nginx_configtest_#{config_name}"
  execute execute_name do
    command '/usr/sbin/nginx -t'
    action :nothing
  end

  template "/etc/nginx/sites-enabled/#{config_name}.conf" do
    cookbook cookbook
    source config_template
    mode '0755'
    owner node['nginx-app']['user']
    group node['nginx-app']['group']
    helpers EasyBib::Helpers
    variables(
      :domain_name => domain_name,
      :doc_root => deploy_dir,
      :app_dir => app_dir,
      :app_name => application,
      :access_log => access_log,
      :nginx_extra => nginx_extras,
      :nginx_local_conf => nginx_local_conf,
      :default_router => default_router,
      :upstream_name => config_name,
      :php_upstream => get_upstream_from_pools(node['php-fpm']['pools'], node['php-fpm']['socketdir']),
      :health_check => health_check,
      :routes_enabled => routes_enabled,
      :routes_denied => routes_denied,
      :htpasswd => htpasswd,
      :listen_opts => listen_opts,
      :cache_config => cache_config,
      :gzip => node['nginx-app']['gzip']
    )
    notifies :run, "execute[#{execute_name}]", :immediately
  end

  # this _should_ work by returning the updated-value of the template provider.
  # however, it does not always, so we are returning true always to make sure the stack is properly restarted.
  # see easybib/issues#1103
  new_resource.updated_by_last_action(true)

end

def get_local_conf(nginx_local_conf)
  return nginx_local_conf if ::File.exist?(nginx_local_conf)
  nil
end

def get_htpasswd(new_resource, application)
  if new_resource.htpasswd.nil?
    htpasswd = node.fetch('nginx-app', {}).fetch(application, {})['htpasswd']
    htpasswd = '' if htpasswd.nil?
  else
    htpasswd = new_resource.htpasswd
  end

  return htpasswd unless htpasswd.include? ':'

  # we have user:password format, so lets encrypt & generate file
  config_name = get_config_name(new_resource)
  filename = "/etc/nginx/#{config_name}.htpasswd"

  user, pass = htpasswd.split(':')
  pass = pass.to_s.crypt(user)

  template filename do
    cookbook 'easybib'
    source 'empty.erb'
    mode '0700'
    owner node['nginx-app']['user']
    group node['nginx-app']['group']
    variables(
      :content => "#{user}:#{pass}"
    )
  end
  filename
end

def get_domain_name(new_resource, node)
  return new_resource.domain_name unless new_resource.domain_name.nil?
  ::EasyBib::Config.get_domains(node, new_resource.app_name)
end

def get_cache_config(new_resource, node)
  return new_resource.cache_config unless new_resource.cache_config.nil?
  node.fetch('nginx-app', {}).fetch('browser_caching', {})
end

def get_nginx_extras(new_resource, node)
  return new_resource.nginx_extras unless new_resource.nginx_extras.nil?
  node.fetch('nginx-app', {}).fetch('extras', {})
end

def get_app_dir(new_resource, node)
  return new_resource.app_dir unless new_resource.app_dir.nil?
  ::EasyBib::Config.get_appdata(node, new_resource.app_name, 'app_dir')
end

def get_deploy_dir(new_resource, node)
  return new_resource.deploy_dir unless new_resource.deploy_dir.nil?
  ::EasyBib::Config.get_appdata(node, new_resource.app_name, 'doc_root_dir')
end

def get_health_check(application, node)
  return node['nginx-app']['health_check'] if node.fetch('nginx-app', {}).fetch(application, {})['health_check'].nil?
  node.fetch('nginx-app', {}).fetch(application, {}).fetch('health_check', {})
end

def get_config_name(resource)
  config_name = resource.app_name

  config_name = resource.config_name unless resource.config_name.empty?

  Chef::Log.debug("CONFIG NAME: #{config_name} - #{resource.app_name} - #{resource.config_name}")
  config_name
end

def get_default_router(stackdefault, resourcedefault, deploy_dir)
  return resourcedefault unless new_resource.default_router.nil?
  return 'index.php' unless ::File.exist?("#{deploy_dir}/#{stackdefault}")
  stackdefault
end

def get_routes(application, node, type)
  node.fetch('nginx-app', {}).fetch(application, {})[type]
end
