unless node['vagrant']
  fail 'Vagrant only!'
end

domain_name = nil
doc_root = nil

if node['vagrant'].attribute?('applications') && node['vagrant']['applications'].attribute?('www')
  domain_name = node['vagrant']['applications']['www']['domain_name']
  doc_root = node['vagrant']['applications']['www']['doc_root_location']

  node.normal.deploy['deploy_to'] = node['vagrant']['applications']['www']['app_root_location']
end

unless node['deploy']['deploy_to']
  fail 'No deploy_to in deploy!'
end

Chef::Log.debug("deploy: #{node['deploy']['deploy_to']}")

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
    :domain_name  => domain_name,
    :php_upstream => ::EasyBib.get_upstream_from_pools(node['php-fpm']['pools'], node['php-fpm']['socketdir']),
    :upstream_name => 'www',
    :environment  => ::EasyBib.get_cluster_name(node),
    :doc_root     => doc_root
  )
  notifies :restart, 'service[nginx]', :delayed
end

easybib_envconfig 'www' do
  stackname 'easybib'
end
