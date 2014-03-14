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

  if ::EasyBib.is_aws(node)
    deploy_dir = "/srv/www/#{new_resource.app_name}/current/#{new_resource.doc_root}"
  elsif !new_resource.deploy_dir.nil?
    deploy_dir = new_resource.deploy_dir
  else
    deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
  end

  config_name = get_config_name(new_resource)

  if new_resource.nginx_extras.nil?
    nginx_extras = node["nginx-app"]["extras"]
  else
    nginx_extras = new_resource.nginx_extras
  end

  config_template = new_resource.config_template
  access_log = new_resource.access_log
  database_config = new_resource.database_config
  domain_config = new_resource.domain_config
  env_config = new_resource.env_config
  domain_name = new_resource.domain_name
  routes_enabled = new_resource.routes_enabled
  routes_denied = new_resource.routes_denied

  default_router = node["nginx-app"]["default_router"]

  if !::File.exists?("#{deploy_dir}/#{default_router}")
    default_router = 'index.php'
  end

  default_router = new_resource.default_router unless new_resource.default_router.nil?

  template "/etc/nginx/sites-enabled/#{config_name}.conf" do
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
      :domain_conf => domain_config,
      :env_conf => env_config,
      :routes_enabled => routes_enabled,
      :routes_denied => routes_denied
    )
  end

  new_resource.updated_by_last_action(true)

end

def get_config_name(resource)
  config_name = resource.app_name
  if !resource.config_name.empty?
    config_name = resource.config_name
  end
  config_name
end
