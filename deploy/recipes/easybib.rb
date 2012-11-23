# custom recipe because of: http://support.scalarium.com/discussions/problems/78-app-is-not-deploying

instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|

  Chef::Log.info("deploy::easybib - app: #{application}, role: #{instance_roles}")

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

  when 'gearmanworker'
    next unless instance_roles.include?('gearman-worker')

  when 'sitescraper'
    next unless instance_roles.include?('sitescraper')

  else
    Chef::Log.info("deploy::easybib - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info("deploy::easybib - Deployment started.")
  Chef::Log.info("deploy::easybib - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

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
