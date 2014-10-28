include_recipe 'smokeping::service'
include_recipe 'nginx-app::service'

cookbook_file "#{node['nginx-app']['config_dir']}/conf.d/smokeping.conf" do
  group node['nginx-app']['group']
  source 'cgi.conf'
  owner node['nginx-app']['user']
  notifies :reload, 'service[nginx]'
end

smokeping_dir = '/usr/share/smokeping/www'

link '/usr/share/nginx/html/smokeping' do
  to smokeping_dir
end

link "#{smokeping_dir}/smokeping.cgi" do
  to '/usr/lib/cgi-bin/smokeping.cgi'
end

config = node['smokeping']['config']

chef_gem "aws-sdk" unless config['aws']['access-key-id'].empty?

template "/etc/smokeping/config.d/Probes" do
  mode 0644
  source "probes.erb"
  variables(
    :probes => config['probes']
  )
  notifies :restart, 'service[smokeping]'
end

template "/etc/smokeping/config.d/Targets" do
  mode 0644
  source "targets.erb"
  variables(
    :menu => config['menu'],
    :targets => config['targets']
  )
  notifies :restart, 'service[smokeping]'
end
