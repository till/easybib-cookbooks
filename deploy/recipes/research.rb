include_recipe "php-fpm::service"

instance_roles = get_instance_roles()
cluster_name   = get_cluster_name()

node["deploy"].each do |application, deploy|

  Chef::Log.info("deploy::research - app: #{application}, role: #{instance_roles}")
  
  next unless deploy["deploying_user"]

  Chef::Log.info("Deploying as user: #{deploy["user"]} and #{deploy["group"]}")

  case application
  when 'easybib_solr_server'
    next unless cluster_name == 'Research Cloud'
    next unless instance_roles.include?('easybibsolr')

    Chef::Log.debug('deploy::research - Setting deploy for SOLR SERVER')

    # fix this: deploy to instance storage
    deploy["deploy_to"]       = "/solr/apache-solr-1.4.1-compiled"
    deploy["restart_command"] = ""

    deploy["user"] = "root"

  when 'ebim2'
    next unless cluster_name == 'Research Cloud'
    if !instance_roles.include?('easybibsolr') && !instance_roles.include?('ebim2')
      next
    end
    deploy["restart_command"] = ""

  when 'ebim2_research_importer'
    next unless cluster_name == 'Research Cloud'
    if !instance_roles.include?('ebim2') && !instance_roles.include?('easybibsolr')
      next
    end
    deploy["restart_command"] = ""

  when 'research_app'
    next unless cluster_name == 'Research Cloud'
    next unless instance_roles.include?('nginxphpapp')

  when 'citationbackup'
    next unless cluster_name == 'Research Cloud'
    next unless instance_roles.include?('backup')

  when 'gearmanworker'
    next unless instance_roles.include?('gearman-worker')

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

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  service "php-fpm-#{application}" do
    service_name "php-fpm"
    supports :reload => true
    action :reload
    only_if do
      application == 'research_app'
    end
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
