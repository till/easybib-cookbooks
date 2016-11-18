%w(edu www webeval).each do |app|

  next if node['vagrant']['applications'].fetch(app, nil).nil?
  template = (app == 'www') ? 'easybib.com.conf.erb' : 'silex.conf.erb'

  easybib_envconfig app

  easybib_nginx app do
    cookbook 'stack-easybib'
    config_template template
    notifies :reload, 'service[nginx]', :delayed
    notifies :restart, 'service[php-fpm]', :delayed
  end

  next unless app == 'www'
  app_dir = node['vagrant']['applications'][app]['app_root_location']
  easybib_supervisor app do
    supervisor_file "#{app_dir}/deploy/supervisor.json"
    app_dir app_dir
    user node['php-fpm']['user']
  end
end
