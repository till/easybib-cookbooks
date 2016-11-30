include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

node['deploy'].each do |application, deploy|

  case application
  when 'aptly'
    next unless allow_deploy(application, 'aptly')
  when 'bibcd'
    next unless allow_deploy(application, 'bibcd')
  when 'bib_opsstatus'
    next unless allow_deploy(application, 'bib_opsstatus', 'bib-opsstatus')
  when 'travis_asset_browser'
    next unless allow_deploy(application, 'travis_asset_browser', 'travis-asset-browser')
  else
    Chef::Log.info("deploy::qa - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  easybib_deploy application do
    deploy_data deploy
  end

  easybib_nginx application do
    config_template 'silex.conf.erb'
    domain_name     deploy['domains'].join(' ')
    htpasswd        "#{deploy['deploy_to']}/current/htpasswd"
    doc_root        deploy['document_root']
    notifies :reload, 'service[nginx]', :delayed
  end

  case application
  when 'aptly'

    include_recipe 'aptly::setup'
    aptly_cronjob 'easybib-s3' do
      path "#{deploy['deploy_to']}/current/"
    end
  end

  service 'php-fpm' do
    action node['php-fpm']['restart-action']
  end

end
