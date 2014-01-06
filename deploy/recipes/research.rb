include_recipe "php-fpm::service"
include_recipe "nginx-app::service"

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::research - app: #{application}, role: #{instance_roles}")
  Chef::Log.info("Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  case application
  when 'easybib_solr_server'
    next unless allow_deploy(application, 'easybib_solr_server', 'easybibsolr')
    Chef::Log.debug('deploy::research - Setting deploy for SOLR SERVER')
    # fix this: deploy to instance storage
    deploy["deploy_to"]       = "/solr/apache-solr-1.4.1-compiled"
    deploy["restart_command"] = ""
    deploy["user"]            = "root"
  when 'ebim2'
    next unless ( allow_deploy(application, 'ebim2') || allow_deploy(application, 'easybibsolr') )
    deploy["restart_command"] = ""
  when 'ebim2_research_importer'
    next unless ( allow_deploy( application, 'ebim2_research_importer', 'ebim2') || allow_deploy(application, 'ebim2_research_importer', 'easybibsolr') )
    deploy["restart_command"] = ""
  when 'research_app'
    next unless allow_deploy(application, 'research_app', 'nginxphpapp')
  when 'citationbackup'
    next unless allow_deploy(application, 'citationbackup', 'backup')
  when 'gearmanworker'
    next unless allow_deploy(application, 'gearmanworker', 'gearman-worker')
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

  easybib_deploy do
    deploy_data deploy
    app application
  end

  next unless application == 'ebim2'

  include_recipe "deploy::ebim2"

  base_dir = deploy["deploy_to"]
  app_dir  = "#{base_dir}/vendor/GearmanManager"
  etc_dir  = "#{base_dir}/etc/gearman"

  link "/usr/local/bin/gearman-manager" do
    to "#{app_dir}/pecl-manager.php"
  end

  link "/etc/gearman-manager" do
    to etc_dir
  end

  link "/etc/init.d/gearman-manager" do
    to "#{base_dir}/bin/gearman-manager.initd"
  end

end
