include_recipe 'php-fpm::service'

if is_aws
  include_recipe 'percona::client'
  include_recipe 'awscli'

  chef_gem 'travis' do
    action :install
  end

end

node['deploy'].each do |application, deploy|

  next unless allow_deploy(application, 'api', 'api-server')

  app_info    = ::EasyBib::Config.get_appdata(node, 'api')

  easybib_deploy "getcourse-#{application}" do
    deploy_data deploy
    app application
    envvar_json_source 'getcourse'
    cronjob_role node['getcourse_deploy']['master_server_layer']
    instance_roles node['opsworks']['instance']['layers']
  end

  # AWScli setup to upload db backups
  credential_dir = "#{node['opsworks']['deploy_user']['home']}/.aws"

  directory credential_dir do
    owner deploy['user']
    group deploy['group']
    mode 0700
  end

  template "#{credential_dir}/credentials" do
    cookbook 'awscli'
    source 'credentials.erb'
    owner deploy['user']
    group deploy['group']
    mode 0600
    variables(
      :key_id => node['getcourse']['env']['aws']['access_key'],
      :secret => node['getcourse']['env']['aws']['secret_key']
    )
  end

  # Monitoring for Gearman:
  include_recipe 'monit::pecl-manager'

  # Cronjob to trigger frontend acceptance tests every three hours
  script_path  = "#{app_info['app_dir']}bin/frontend-acceptance.rb"
  jobname      = node['getcourse_deploy']['frontend_acceptance_travis_job_name']
  travis_token = node['getcourse_deploy']['travis_token']
  cmd          = "#{script_path} '#{jobname}' '#{travis_token}'"

  cron_d 'frontend-acceptance-tests' do
    action :create
    hour 3
    user deploy['user']
    command cmd
    path '/usr/local/bin:/usr/bin:/bin'
    only_if do
      ::EasyBib.deploy_crontab?(
        node['opsworks']['instance']['layers'],
        node['getcourse_deploy']['master_server_layer']
      )
    end
  end

  service 'php-fpm' do
    action :reload
  end

end
