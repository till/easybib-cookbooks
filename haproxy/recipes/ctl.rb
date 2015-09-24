Chef::Resource.send(:include, EasyBib)
base_path = node['haproxy']['ctl']['base_path']

# ensure directory exists
directory base_path do
  owner     'root'
  group     'root'
  mode      '0755'
  action    :create
  recursive true
end

git "#{base_path}/haproxyctl" do
  repository 'git://github.com/easybiblabs/haproxyctl.git'
  reference node['haproxy']['ctl']['version']
  action :sync
end

link '/etc/init.d/haproxyctl' do
  to "#{base_path}/haproxyctl/bin/haproxyctl"
end

### haproxyctl statsd stuff ###
statsd_host = node['haproxy']['ctl']['statsd']['host']
statsd_port = node['haproxy']['ctl']['statsd']['port']
directory '/etc/haproxy/haproxyctl' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

template '/etc/haproxy/haproxyctl/instance-name' do
  source 'haproxyctl.instance-name.erb'
  variables(
    :stack_name => node['easybib_deploy']['envtype'],
    :host_name  => get_hostname(node, true)
  )
end

cron_d 'haproxyctl_statsd' do
  action :create
  command "#{base_path}/haproxyctl/bin/haproxyctl statsd > /dev/udp/#{statsd_host}/#{statsd_port}"
  path node['easybib_deploy']['cron_path']
end
