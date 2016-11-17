node['deploy'].each do |application, deploy|
  case application
  when 'gearmanworker'
    next unless allow_deploy(application, 'gearmanworker', 'gearman-worker')

  else
    Chef::Log.info("stack-easybib::deploy-gearman-worker - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
  end

  include_recipe 'monit::pecl-manager'
end
