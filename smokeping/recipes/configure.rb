include_recipe 'smokeping::service'
include_recipe 'nginx-app::service'

easybib_nginx 'smokeping' do
  config_template 'smokeping.conf.erb'
  notifies :restart, 'service[nginx]', :delayed
end

smokeping_dir = '/usr/share/smokeping/www'
smokeping_etc = '/etc/smokeping/config.d'

link '/usr/share/nginx/html/smokeping' do
  to smokeping_dir
end

link "#{smokeping_dir}/smokeping.cgi" do
  to '/usr/lib/cgi-bin/smokeping.cgi'
end

config = node['smokeping']

chef_gem 'aws-sdk' if is_aws

config['directories'].each do |key, path|
  directory path do
    mode 0775
    user 'smokeping'
    group node['nginx-app']['group']
    recursive true
  end
end

pathnames = config['pathnames'].merge(config['directories'])

template "#{smokeping_etc}/pathnames" do
  mode 0644
  source 'pathnames.erb'
  variables(
    :pathnames => pathnames
  )
  notifies :reload, 'service[smokeping]'
end

template "#{smokeping_etc}/Probes" do
  mode 0644
  source 'probes.erb'
  variables(
    :probes => config['probes']
  )
  notifies :reload, 'service[smokeping]'
end

template "#{smokeping_etc}/Targets" do
  mode 0644
  source 'targets.erb'
  variables(
    :menu => config['menu'],
    :targets => config['targets']
  )
  notifies :reload, 'service[smokeping]'
end
