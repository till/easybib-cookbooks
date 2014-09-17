action :remove do
  config_name = get_config_name(new_resource)
  execute "rm /etc/nginx/sites-enabled/#{config_name}.conf" do
    only_if do
      File.exist?("/etc/nginx/sites-enabled/#{config_name}.conf")
    end
  end

  new_resource.updated_by_last_action(true)
end

action :setup do

  if new_resource.deploy_dir.nil?
    if ::EasyBib.is_aws(node)
      deploy_dir = "/srv/www/#{new_resource.app_name}/current/#{new_resource.doc_root}"
    else
      deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
    end
  else
    deploy_dir = new_resource.deploy_dir
  end

  config_name = get_config_name(new_resource)

  if new_resource.nginx_extras.nil?
    nginx_extras = node["nginx-app"]["extras"]
  else
    nginx_extras = new_resource.nginx_extras
  end

  if new_resource.cache_config.nil?
    cache_config = node["nginx-app"]["cache"]
  else
    cache_config = new_resource.cache_config
  end

  config_template = new_resource.config_template
  access_log = new_resource.access_log
  database_config = new_resource.database_config
  env_config = new_resource.env_config
  domain_name = new_resource.domain_name
  htpasswd = new_resource.htpasswd
  application = new_resource.app_name
  listen_opts = new_resource.listen_opts

  routes_enabled = nil
  routes_denied  = nil
  health_check   = node["nginx-app"]["health_check"]
  Chef::Log.debug("Health Check is now #{health_check}")

  if node["nginx-app"].attribute?(application)
    if node["nginx-app"][application].attribute?("routes_enabled")
      routes_enabled = node["nginx-app"][application]["routes_enabled"]
    end
    if node["nginx-app"][application].attribute?("routes_denied")
      routes_denied = node["nginx-app"][application]["routes_denied"]
    end
    if node["nginx-app"][application].attribute?("health_check")
      health_check = node["nginx-app"][application]["health_check"]
      Chef::Log.debug("Health Check is now #{health_check}")
    end
  else
    Chef::Log.info("No routes_enabled/routes_denied found for #{application}")
  end

  default_router = node["nginx-app"]["default_router"]

  if !::File.exist?("#{deploy_dir}/#{default_router}")
    default_router = 'index.php'
  end

  default_router = new_resource.default_router unless new_resource.default_router.nil?

  t = template "/etc/nginx/sites-enabled/#{config_name}.conf" do
    cookbook "nginx-app"
    source config_template
    mode "0755"
    owner node["nginx-app"]["user"]
    group node["nginx-app"]["group"]
    variables(
      :php_user => node["php-fpm"]["user"],
      :domain_name => domain_name,
      :doc_root => deploy_dir,
      :access_log => access_log,
      :nginx_extra => nginx_extras,
      :default_router => default_router,
      :upstream => config_name,
      :db_conf => database_config,
      :env_conf => env_config,
      :health_check => health_check,
      :routes_enabled => routes_enabled,
      :routes_denied => routes_denied,
      :htpasswd => htpasswd,
      :listen_opts => listen_opts,
      :cache_config => cache_config,
      :gzip => node["nginx-app"]["gzip"]
    )
  end

  # this _should_ work by returning the updated-value of the template provider.
  # however, it does not always, so we are returning true always to make sure the stack is properly restarted.
  # see easybib/issues#1103
  new_resource.updated_by_last_action(true)

end

def get_config_name(resource)
  config_name = resource.app_name
  if !resource.config_name.empty?
    config_name = resource.config_name
  end
  config_name
end
