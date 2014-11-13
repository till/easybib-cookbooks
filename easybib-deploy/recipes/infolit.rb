include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node['deploy'].each do |application, deploy|

  case application

  when 'infolit'
    config_template = 'infolit.conf.erb'
    next unless allow_deploy(application, 'infolit', 'nginxphpapp')

  when 'rr_webeval'
    config_template = 'silex.conf.erb'
    next unless allow_deploy(application, 'rr_webeval', 'nginxphpapp')

  else
    Chef::Log.info("deploy::infolit - #{application} skipped")
    next
  end

  Chef::Log.info('deploy::infolit - Deployment started.')
  Chef::Log.info("deploy::infolit - Deploying as user: #{deploy['user']} and #{deploy['group']}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  # clean up old config, when we deployed infolit with nginx-app::configure
  # the webserver config was named 'easybib.com.conf' then, it now is infolit.conf
  # this is "one time use only", can be removed in december 2014
  file '/etc/nginx/sites-enabled/easybib.com.conf' do
    action :delete
    only_if { ::File.exist?('/etc/nginx/sites-enabled/easybib.com.conf') }
  end

  easybib_nginx application do
    config_template config_template
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    htpasswd "#{deploy['deploy_to']}/current/htpasswd"
    notifies :restart, 'service[nginx]', :delayed
  end

  service 'php-fpm' do
    action :reload
  end

end
