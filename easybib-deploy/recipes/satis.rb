node['deploy'].each do |application, deploy|

  case application
  when 'satis'
    next unless allow_deploy(application, 'satis', 'satis')

  when 'easybib_private_satis'
    next unless allow_deploy(application, 'easybib_private_satis', 'satis')

  when 'satis_s3'
    next unless allow_deploy(application, 'satis_s3', 'satis')

  else
    Chef::Log.info("deploy::satis - #{application} skipped")
    next
  end

  Chef::Log.info("deploy::satis - Deploying as user: #{deploy['user']} and #{deploy['group']} to #{deploy['deploy_to']}")

  easybib_deploy application do
    deploy_data deploy
    app application
  end

  %w(/mnt/satis-output/ /mnt/composer-tmp/).each do |dir|
    directory dir do
      recursive true
      owner  node['nginx-app']['user']
      group  node['nginx-app']['group']
      mode  0755
      action :create
    end
  end

  doc_root = ::EasyBib::Config.get_appdata(node, application, 'doc_root_dir')

  template "/etc/nginx/sites-enabled/#{application}.conf" do
    cookbook 'nginx-app'
    source 'satis.conf.erb'
    mode   '0755'
    owner  node['nginx-app']['user']
    group  node['nginx-app']['group']
    variables(
      :doc_root       => doc_root,
      :domain_name    => deploy['domains'].join(' '),
      :htpasswd       => "#{deploy['deploy_to']}/current/htpasswd",
      :access_log     => 'off',
      :nginx_extra    => node['nginx-app']['extras']
    )
    notifies :reload, 'service[nginx]', :delayed
  end

end
