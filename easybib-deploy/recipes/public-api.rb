include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

cluster_name = get_cluster_name
config_name = ''

node['deploy'].each do |application, deploy|

  case application
  when 'easybib_api'
    next unless allow_deploy(application, 'easybib_api', 'bibapi')
    config_name = 'easybib-api.conf.erb'
  when 'citation_apis'
    next unless allow_deploy(application, 'citation_apis', 'citation-apis')
    config_name = 'public-api.conf.erb'
  else
    Chef::Log.info("deploy::#{application} using wrong deploy recipe in: #{cluster_name}")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  easybib_nginx application do
    config_template config_name
    domain_name     deploy['domains'].join(' ')
    doc_root        deploy['document_root']
    access_log      'off'
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
    only_if do
      config_name != ''
    end
  end
end
