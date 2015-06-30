Chef::Resource.send(:include, EasyBib)

nodejs_npm "install deps" do
  path node['statsd']['deploy_dir']
  action :nothing
end

git node['statsd']['deploy_dir'] do
  repository node['statsd']['repository']
  revision node['statsd']['branch']
  not_if is_aws
  notifies :install, "nodejs_npm[install deps]"
end
