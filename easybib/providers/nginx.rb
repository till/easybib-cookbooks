action :remove do
  config_name = get_config_name(new_resource)
  execute "rm /etc/nginx/sites-enabled/#{config_name}.conf" do
    only_if do
      File.exists?("/etc/nginx/sites-enabled/#{config_name}.conf")
    end
  end

  new_resource.updated_by_last_action(true)
end

action :setup do

  if ::EasyBib::is_aws(node)
    deploy_dir = "/srv/www/#{new_resource.app_name}/current/#{new_resource.doc_root}"
  else
    deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
  end

  config_name = get_config_name(new_resource)

  config_template = new_resource.config_template
  access_log = new_resource.access_log
  database_config = new_resource.database_config
  domain_config = new_resource.domain_config
  domain_name = new_resource.domain_name

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
      :nginx_extra => node["nginx-app"]["extras"],
      :default_router => node["nginx-app"]["default_router"],
      :upstream => config_name,
      :db_conf => database_config,
      :domain_conf => domain_config
    )
  end

  new_resource.updated_by_last_action(true)

end

def get_config_name(resource)
  config_name = resource.app_name
  if !resource.config_name.empty?
    config_name = resource.config_name
  end
  return config_name
end
