include_recipe 'nginx-app::service'
include_recipe 'php-fpm::service'

node['deploy'].each do |application, deploy|

  case application
  when 'citation_apis'
    next unless allow_deploy(application, 'citation_apis', 'citation-apis')
  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'bibapi')
  when 'pdf_autocite'
    next unless allow_deploy(application, 'pdf_autocite')
  when 'sitescraper'
    next unless allow_deploy(application, 'sitescraper')
  when 'forms'
    next unless allow_deploy(application, 'forms')
  else
    Chef::Log.info("stack-citationapi::deploy-citationapi - #{application} (in stack-citationapi) skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started as user: #{deploy[:user]} and #{deploy[:group]}")

  # clean up old config before migration
  file '/etc/nginx/sites-enabled/easybib.com.conf' do
    action :delete
    ignore_failure true
  end

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  easybib_nginx application do
    cookbook 'stack-citationapi'
    config_template 'default-web-nginx.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end

end
