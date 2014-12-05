config = 'sitescraper'

access_log = node['nginx-app']['access_log']

easybib_nginx config do
  app_name        config
  config_template 'internal-api.conf.erb'
  doc_root        'www'
  access_log      access_log
  nginx_extras    'sendfile off;'
  notifies :restart, 'service[nginx]', :delayed
end

easybib_envconfig config
