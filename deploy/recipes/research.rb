include_recipe "php-fpm::service"

instance_roles = node[:scalarium][:instance][:roles]

node[:deploy].each do |application, deploy|

  next unless node[:scalarium][:cluster][:name] == 'Research Cloud'

  Chef::Log.debug("deploy::research - app: #{application}, role: #{instance_roles}")
  Chef::Log.debug("Deploying as user: #{deploy[:user]}")

  case application

  when 'easybib_solr_server'
    next unless instance_roles.include?('easybibsolr')

    Chef::Log.debug('deploy::research - Setting deploy for SOLR SERVER')

    # fix this: deploy to instance storage
    deploy[:deploy_to] = "/solr/apache-solr-1.4.1-compiled"

    deploy[:user] = "root"

  when 'ebim2'
    if !instance_roles.include?('easybibsolr') && !instance_roles.include?('ebim2')
      next
    end

  when 'ebim2_research_importer'
    if !instance_roles.include?('ebim2') && !instance_roles.include?('easybibsolr')
      next
    end
      
  when 'research_app'
    next unless instance_roles.include?('nginxphpapp')

  when 'citationbackup'
    next unless instance_roles.include?('backup')

  when 'gearmanworker'
    next unless instance_roles.include?('gearman-worker')

  else
    Chef::Log.debug("deploy::research - #{application} (in #{node[:scalarium][:cluster][:name]}) skipped")
    next
  end

  Chef::Log.debug("deploy::research - Deployment started.")

  scalarium_deploy_dir do
    user  deploy[:user]
    group deploy[:group]
    path  deploy[:deploy_to]
  end

  scalarium_deploy do
    deploy_data deploy
    app application
  end

  if application == 'ebim2'
    include_recipe "deploy::ebim2"

    base_dir = deploy[:deploy_to]
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

  if application == 'research_app'
    service "php-fpm" do
      action :reload
    end
  end

end
