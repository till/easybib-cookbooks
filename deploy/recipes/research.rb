include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::research - app: #{application}")
  Chef::Log.info("Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  case application
  when 'easybib_solr_server'
    next unless allow_deploy(application, 'easybib_solr_server', 'easybibsolr')
    deploy["restart_command"] = ""
    deploy["user"]            = "root"
  when 'research_app'
    next unless allow_deploy(application, 'research_app', 'research_app')
  else
    Chef::Log.info("deploy::research - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::research - Deployment started.")

  opsworks_deploy_dir do
    user  deploy["user"]
    group deploy["group"]
    path  deploy["deploy_to"]
  end

  easybib_deploy application do
    deploy_data deploy
    app application
  end
end
