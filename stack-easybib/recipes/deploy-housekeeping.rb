include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node['deploy'].each do |application, deploy|

  case application
  when 'easybib'
    next unless allow_deploy(application, 'easybib', 'housekeeping')
  when 'sharing'
    next unless allow_deploy(application, 'sharing', 'housekeeping')
  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'housekeeping')
  else
    Chef::Log.info("deploy::housekeeping - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
  end

end
