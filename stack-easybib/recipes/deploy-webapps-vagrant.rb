%w(www schools webeval).each do |app|

  next if node['vagrant']['applications'].fetch(app, nil).nil?
  template = (app == 'www') ? 'easybib.com.conf.erb' : 'silex.conf.erb'

  easybib_envconfig app

  easybib_nginx app do
    cookbook 'stack-easybib'
    config_template template
    notifies :reload, 'service[nginx]', :delayed
    notifies :restart, 'service[php-fpm]', :delayed
  end
end
