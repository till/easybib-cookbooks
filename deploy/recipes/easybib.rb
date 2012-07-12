# custom recipe because of: http://support.scalarium.com/discussions/problems/78-app-is-not-deploying

instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|

  Chef::Log.debug("deploy::easybib - app: #{application}, role: #{instance_roles}")

  case application
  when 'easybib'
    if !['EasyBib', 'EasyBib Playground', 'Fruitkid'].include?(cluster_name)
      next
    end
    if !instance_roles.include?('nginxphpapp') && !instance_roles.include?('testapp')
      next
    end

  when 'easybib_api'
    next unless instance_roles.include?('bibapi')

  when 'easybib_solr_server'
    next unless cluster_name == 'Research Cloud'
    next unless instance_roles.include?('easybibsolr')

    Chef::Log.debug('deploy::easybib - Setting deploy for SOLR SERVER')

    # fix this: deploy to instance storage
    deploy[:deploy_to]       = "/solr/apache-solr-1.4.1-compiled"
    deploy[:restart_command] = ""

    deploy[:user] = "root"

  when 'ebim2'
    next unless cluster_name == 'Research Cloud'
    if !instance_roles.include?('easybibsolr') && !instance_roles.include?('ebim2')
      next
    end
    deploy[:restart_command] = ""
  
  when 'ebim2_research_importer'
    next unless cluster_name == 'Research Cloud'
    if !instance_roles.include?('ebim2') && !instance_roles.include?('easybibsolr')
      next
    end
    deploy[:restart_command] = ""
      
  when 'research_app'
    next unless cluster_name == 'Research Cloud'
    next unless instance_roles.include?('nginxphpapp')

  when 'citationbackup'
    next unless cluster_name == 'Research Cloud'
    next unless instance_roles.include?('backup')

  when 'citation_anlytics'
    next unless cluster_name == 'Citation Analytics'
    next unless instance_roles.include?('elasticsearch')

    Chef::Log.debug('deploy.easybib - Prepare for git checkout')

  when 'gearmanworker'
    next unless instance_roles.include?('gearman-worker')

  when 'sitescraper'
    next unless instance_roles.include?('sitescraper')

  when 'research'
    next unless cluster_name == 'Research Cloud'
    next unless instance_roles.include?('nginxphpapp')

  else
    Chef::Log.debug("deploy::easybib - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.debug("deploy::easybib - Deployment started.")

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
      to "#{app_dir}/#{node[:gearman_manager][:type]}-manager.php"
    end

    link "/etc/gearman-manager" do
      to etc_dir
    end

    link "/etc/init.d/gearman-manager" do
      to "#{base_dir}/bin/gearman-manager.initd"
    end

  end

end
