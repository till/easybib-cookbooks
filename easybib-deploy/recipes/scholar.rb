include_recipe 'php-fpm::service'
include_recipe 'nginx-app::service'

supervisor_role = node['easybib_deploy']['supervisor_role']

node['deploy'].each do |application, deploy|
  listen_opts = nil

  case application
  when 'notebook'
    next unless allow_deploy(application, 'notebook', 'erlang')
  when 'scholar'
    listen_opts = 'default_server'
    next unless allow_deploy(application, 'scholar', ['nginxphpapp', supervisor_role])
  else
    Chef::Log.info("deploy::scholar - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::#{application} - Deployment started.")
  Chef::Log.info("deploy::#{application} - Deploying as user: #{deploy[:user]} and #{deploy[:group]}")

  scm_options = node[:opsworks_custom_cookbooks][:scm] if node[:opsworks_custom_cookbooks][:scm][:type].to_s == 's3'

  template '/root/.s3curl' do
    cookbook 'scm_helper'
    source 's3curl.erb'
    mode '0600'
    variables(
      :access_key => scm_options[:user],
      :secret_key => scm_options[:password]
    )
    only_if application == 'notebook' && scm_options
  end

  tmpdir = Dir.mktmpdir('opsworks')
  directory tmpdir do
    mode 0755
    only_if application == 'notebook' && scm_options
  end

  local_path = "#{tmpdir}/#{File.basename(scm_options[:repository])}"

  execute "Download application from S3: #{scm_options[:repository]}" do
    command "#{node[:opsworks_agent][:current_dir]}/bin/s3curl.pl --id opsworks -- -o #{local_path} #{scm_options[:repository]}"
    retries 2
    retry_delay 10
    only_if application == 'notebook' && scm_options
  end

  erlang_otp_release do
    destination "/srv/www/#{application}/releases"
    artifact "#{local_path}"
    reboot true
    only_if application == 'notebook' && scm_options
  end

  easybib_deploy application do
    deploy_data deploy
    app application
    only_if application == 'scholar'
    supervisor_role supervisor_role
  end

  easybib_nginx application do
    config_template 'scholar.conf.erb'
    domain_name deploy['domains'].join(' ')
    doc_root deploy['document_root']
    htpasswd "#{deploy['deploy_to']}/current/htpasswd"
    nginx_local_conf "#{::EasyBib::Config.get_appdata(node, application, 'app_dir')}/deploy/nginx.conf"
    listen_opts listen_opts
    notifies :reload, 'service[nginx]', :delayed
    notifies node['easybib-deploy']['php-fpm']['restart-action'], 'service[php-fpm]', :delayed
    only_if application == 'scholar'
  end

end
