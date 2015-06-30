Chef::Resource.send(:include, EasyBib)

group node['statsd']['group'] do
  action :create
end

user node['statsd']['user'] do
  home node['statsd']['deploy_dir']
  manage_home true
  group node['statsd']['group']
  shell '/bin/false'
  system true
  action :create
end

target_dir = "#{node['statsd']['deploy_dir']}/#{node['statsd']['branch']}"

nodejs_npm 'install deps' do
  path target_dir
  user node['statsd']['user']
  group node['statsd']['group']
  action :nothing
end

git target_dir do
  repository node['statsd']['repository']
  revision node['statsd']['branch']
  user node['statsd']['user']
  group node['statsd']['group']
  not_if is_aws
  notifies :install, "nodejs_npm[install deps]"
end
