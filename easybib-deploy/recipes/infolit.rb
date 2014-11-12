include_recipe 'php-fpm::service'

node['deploy'].each do |application, deploy|

  case application

  when 'infolit'
    next unless allow_deploy(application, 'infolit', 'nginxphpapp')

  when 'rr-webeval'
    next unless allow_deploy(application, 'rr-webeval', 'nginxphpapp')

  else
    Chef::Log.info("deploy::infolit - #{application} (in #{cluster_name}) skipped")
    next
  end

  Chef::Log.info('deploy::infolit - Deployment started.')
  Chef::Log.info("deploy::infolit - Deploying as user: #{deploy['user']} and #{deploy['group']}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  service 'php-fpm' do
    action :reload
  end

end
