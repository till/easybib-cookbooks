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

  unless application == 'pdf_autocite'
    easybib_nginx application do
      cookbook 'stack-citationapi'
      config_template 'default-web-nginx.conf.erb'
      notifies :reload, 'service[nginx]', :delayed
      notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
    end

    next
  end

  # PDF-Autocite is a Gearman application and needs to be handled separately.

  default_router = if deploy.attribute?('default_router')
                     deploy['default_router']
                   else
                     'index.php'
                   end

  template = 'default-web-nginx.conf.erb'

  domain_name        = ::EasyBib::Config.get_appdata(node, application, 'domains')
  doc_root_location  = ::EasyBib::Config.get_appdata(node, application, 'doc_root_dir')
  app_dir            = ::EasyBib::Config.get_appdata(node, application, 'app_dir')

  easybib_nginx application do
    cookbook 'stack-citationapi'
    config_template template
    deploy_dir doc_root_location
    default_router default_router
    domain_name domain_name
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
  end

  easybib_envconfig application

  easybib_supervisor "#{application}_supervisor" do
    supervisor_file "#{app_dir}/deploy/supervisor.json"
    app_dir app_dir
    app application
    user node['php-fpm']['user']
  end

  easybib_gearmanw app_dir
end
