include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::research - app: #{application}")
  Chef::Log.info("Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  case application
  when 'research_solr'
    next unless allow_deploy(application, 'research_solr', 'easybib_solr_server')
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

  execute "copy config from git to #{solr_base}" do
    cwd     solr_base
    command "cp -R #{node["apache_solr"]["config_source_dir"]}/* #{node["apache_solr"]["base_dir"]}/solr/"
    only_if do
      application == 'research_solr'
    end
  end
end
