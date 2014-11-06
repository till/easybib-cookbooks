include_recipe 'smokeping::service'
include_recipe 'nginx-app::service'

cookbook_file "#{node['nginx-app']['config_dir']}/conf.d/smokeping.conf" do
  group node['nginx-app']['group']
  source 'cgi.conf'
  owner node['nginx-app']['user']
  notifies :reload, 'service[nginx]'
end

smokeping_dir = '/usr/share/smokeping/www'
smokeping_etc = '/etc/smokeping/config.d'

link '/usr/share/nginx/html/smokeping' do
  to smokeping_dir
end

link "#{smokeping_dir}/smokeping.cgi" do
  to '/usr/lib/cgi-bin/smokeping.cgi'
end

config = node['smokeping']['config']

chef_gem 'aws-sdk' unless config['aws']['access-key-id'].empty?

config['pathnames'].each do |key, path|
  next unless path[0, 1] == '/'
  directory path do
    mode 0755
    user 'smokeping'
    recursive  true
  end
end

template "#{smokeping_etc}/pathnames" do
  mode 0644
  source 'pathnames.erb'
  variables(
    :pathnames => config['pathnames']
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
