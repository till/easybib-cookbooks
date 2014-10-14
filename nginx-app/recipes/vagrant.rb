unless node['vagrant']
  fail 'Vagrant only!'
end

template '/etc/nginx/sites-enabled/easybib.com.conf' do
  source node['nginx-app']['conf_file']
  mode   '0755'
  owner  node['nginx-app']['user']
  group  node['nginx-app']['group']
  helpers EasyBib::Upstream
  variables(
    :js_alias     => node['nginx-app']['js_modules'],
    :img_alias    => node['nginx-app']['img_modules'],
    :css_alias    => node['nginx-app']['css_modules'],
    :deploy       => node['deploy'],
    :application  => 'easybib',
    :access_log   => node['nginx-app']['access_log'],
    :listen_opts  => 'default_server',
    :nginx_extra  => 'sendfile  off;',
    :domain_name  => ::EasyBib::Config.get_domains(node, 'easybib'),
    :php_upstream => ::EasyBib.get_upstream_from_pools(node['php-fpm']['pools'], node['php-fpm']['socketdir']),
    :upstream_name => 'www',
    :environment  => ::EasyBib.get_cluster_name(node),
    :doc_root     => ::EasyBib::Config.get_appdata(node, 'easybib', 'doc_root_dir'),
    :app_dir      => ::EasyBib::Config.get_appdata(node, 'easybib', 'app_dir')
  )
  notifies :restart, 'service[nginx]', :delayed
end

easybib_envconfig 'easybib' do
  stackname 'easybib'
end
