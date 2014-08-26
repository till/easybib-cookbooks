include_recipe "easybib::role-phpapp"

include_recipe "php-posix"
include_recipe "php-zip"
include_recipe "php-intl"
include_recipe "php-gearman"
include_recipe "php-mysqli::configure"

include_recipe "snooze"
include_recipe "bash::bashrc"
include_recipe "bash::configure"
include_recipe "getcourse-deploy::api"

if is_aws
  stack_applications = node['deploy'].keys
else
  stack_applications = ['api', 'ff']
end

stack_applications.each do |app|
  case app
  when 'api', 'ff'
    htpasswd_path = nil
    domain_name = ::EasyBib::Config.get_domains(node, app, 'getcourse')
    app_info    = ::EasyBib::Config.get_appdata(app)
    deploy_dir  = app_info['doc_root_dir']

    if app == 'api'
      include_recipe "nginx-app::cache"
    elsif app == 'ff' && is_aws
      htpasswd_path = "#{app_info['app_dir']}deploy/htpasswd"
    end

    env_conf = ""
    if has_env?("getcourse")
      env_conf = get_env_for_nginx("getcourse")
    end

    easybib_nginx app do
      config_template "silex.conf.erb"
      htpasswd htpasswd_path
      domain_name domain_name
      doc_root deploy_dir
      env_config env_conf
      notifies :restart, "service[nginx]", :delayed
    end
  else
    Chef::Log.info('Application #{app} is not a php app, skipping in role-phpapp')
  end
end

unless is_aws
  include_recipe "getcourse-deploy::vagrant-gearman"
end
