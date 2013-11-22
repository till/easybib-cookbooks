action :remove do
  new_resource.updated_by_last_action(true)
end

action :setup do

  if new_resource.aws == true
    deploy_dir = "/srv/www/#{new_resource.app_name}/current/web"
  else
    deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
  end

  config_name = new_resource.app_name
  if !new_resource.config_name.empty?
    config_name = new_resource.config_name
  end

  config_template = new_resource.config_template
  access_log = new_resource.access_log
  database_config = new_resource.database_config
  domain_config = new_resource.domain_config

  template "/etc/nginx/sites-enabled/#{config}.conf" do
    source config_template
    mode   "0755"
    owner  node["nginx-app"]["user"]
    group  node["nginx-app"]["group"]
    variables(
      :php_user    => node["php-fpm"]["user"],
      :doc_root    => deploy_dir,
      :access_log  => access_log,
      :nginx_extra => node["nginx-app"]["extras"],
      :default_router => node["nginx-app"]["default_router"],
      :xhprof_enable => node["nginx-app"]["xhprof"]["enable"],
      :upstream => config,
      :db_conf => database_config,
      :domain_conf => domain_config
    )
  end

  new_resource.updated_by_last_action(true)

end
