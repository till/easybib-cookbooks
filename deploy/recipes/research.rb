include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::research - app: #{application}")
  Chef::Log.info("Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  case application
  when 'easybib_solr_server'
    next unless allow_deploy(application, 'easybib_solr_server', 'easybibsolr')
    Chef::Log.debug('deploy::research - Setting deploy for SOLR SERVER')
    # fix this: deploy to instance storage
    deploy["deploy_to"]       = "/solr/apache-solr-1.4.1-compiled"
    deploy["restart_command"] = ""
    deploy["user"]            = "root"
  when 'research_app'
    next unless allow_deploy(application, 'research_app', 'research_app')
  else
    Chef::Log.info("deploy::research - #{application} (in #{cluster_name}) skipped")
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
