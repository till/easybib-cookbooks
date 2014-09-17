include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

cluster_name   = get_cluster_name

node['deploy'].each do |application, deploy|

  case application
  when 'crossref_service'
    next unless allow_deploy(application, 'crossref_service', 'crossref-www')
  when 'highbeam'
    next unless allow_deploy(application, 'highbeam')
  when 'jstor'
    next unless allow_deploy(application, 'jstor')
  when 'oclc_eswitch'
    next unless allow_deploy(application, 'oclc_eswitch', 'oclc-eswitch')
  when 'proquest'
    next unless allow_deploy(application, 'proquest')
  when 'recommend'
    next unless allow_deploy(application, 'recommend')
  when 'sitescraper'
    next unless allow_deploy(application, 'sitescraper')
  when 'worldcat'
    next unless allow_deploy(application, 'worldcat')
  when 'yahooboss'
    next unless allow_deploy(application, 'yahooboss')
  else
    Chef::Log.info("deploy::internal-api - #{application} (in #{cluster_name}) skipped")
    next
  end

  env_conf = ''
  if has_env?(application)
    env_conf = get_env_for_nginx(application)
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  easybib_nginx application do
    config_template 'internal-api.conf.erb'
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    access_log      'off'
    notifies :restart, 'service[nginx]', :delayed
  end

  service 'php-fpm' do
    action :reload
  end

end
