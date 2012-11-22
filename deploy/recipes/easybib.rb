# custom recipe because of: http://support.scalarium.com/discussions/problems/78-app-is-not-deploying

instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|

  Chef::Log.info("deploy::easybib - app: #{application}, role: #{instance_roles}")
  Chef::Log.info("Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

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

  when 'infolit'
    next unless cluster_name == 'InfoLit'
    next unless instance_roles.include?('nginxphpapp')
  
  when 'citation_anlytics'
    next unless cluster_name == 'Citation Analytics'
    next unless instance_roles.include?('elasticsearch')

    Chef::Log.debug('deploy.easybib - Prepare for git checkout')

  when 'gearmanworker'
    next unless instance_roles.include?('gearman-worker')

  when 'sitescraper'
    next unless instance_roles.include?('sitescraper')

  else
    Chef::Log.info("deploy::easybib - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::easybib - Deployment started.")

  scalarium_deploy_dir do
    user  deploy[:user]
    group deploy[:group]
    path  deploy[:deploy_to]
  end

  scalarium_deploy do
    deploy_data deploy
    app application
  end

end
