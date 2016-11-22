get_apps_to_deploy.each do |application, deploy|
  case application
  when 'rds_test'
    unless allow_deploy(application, 'rds_test', %w(nginxphpapp))
      Chef::Log.info("stack-easybib::deploy-rdstest - #{application} skipped")
      next
    end
  else
    Chef::Log.info("stack-easybib::deploy-rdstest - #{application} skipped")
    next
  end

  Chef::Log.info("stack-easybib::deploy-rdstest - Deployment started as #{deploy[:user]}:#{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
  end

  cron_d 'rds_test' do
    command 'cd /srv/www/rds_test/current; php rds-test.php 2>&1 | logger -t rds_test'
    hour '*'
    minute '*'
    path '/usr/local/bin:/usr/bin'
  end
end
