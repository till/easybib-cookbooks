unless node['vagrant']
  raise 'Vagrant only!'
end

include_recipe 'nginx-app::service'
include_recipe 'supervisor'

app_dir = EasyBib::Config.get_appdata(node, 'www', 'app_dir')

template '/etc/nginx/sites-enabled/easybib.com.conf' do
  source node['nginx-app']['conf_file']
  mode   '0755'
  owner  node['nginx-app']['user']
  group  node['nginx-app']['group']
  helpers EasyBib::Helpers
  variables(
    :js_alias     => node['nginx-app']['js_modules'],
    :img_alias    => node['nginx-app']['img_modules'],
    :css_alias    => node['nginx-app']['css_modules'],
    :deploy       => node['deploy'],
    :application  => 'easybib',
    :access_log   => node['nginx-app']['access_log'],
    :listen_opts  => 'default_server',
    :nginx_extra  => 'sendfile  off;',
    :domain_name  => get_domains(node, 'www'),
    :php_upstream => get_upstream_from_pools(node['php-fpm']['pools'], node['php-fpm']['socketdir']),
    :upstream_name => 'www',
    :environment  => get_cluster_name(node),
    :doc_root     => get_appdata(node, 'www', 'doc_root_dir'),
    :app_dir      => app_dir,
    :nginx_local_conf => "#{app_dir}/deploy/nginx.conf"
  )
  notifies :reload, 'service[nginx]', :delayed
end

easybib_envconfig 'www' do
  stackname 'easybib'
end

easybib_supervisor 'www_supervisor' do
  supervisor_file "#{app_dir}deploy/supervisor.json"
  app_dir app_dir
  app 'www'
  user node['php-fpm']['user']
  ignore_failure true
end
