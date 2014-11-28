is_precise = (node.fetch('lsb', {})['codename'] == 'precise')
if is_precise
  package 'ia32-libs'
else
  package 'lib32z1'
end

directory node['ezproxy']['install_dir'] do
  action :create
end

remote_file "#{node['ezproxy']['install_dir']}/#{node['ezproxy']['bin_name']}" do
  source node['ezproxy']['binary_url']
  mode '0755'
end

# ezproxy -m installs all default files, and does always exit 1 - hence ignore_failure
execute 'initial ezproxy run' do
  cwd node['ezproxy']['install_dir']
  command "#{node['ezproxy']['install_dir']}/#{node['ezproxy']['bin_name']} -m"
  ignore_failure true
end

# ezproxy -m installs all default files, and does always exit 1 - hence ignore_failure
execute 'create ezproxy init scripts' do
  cwd node['ezproxy']['install_dir']
  command "#{node['ezproxy']['install_dir']}/#{node['ezproxy']['bin_name']} -si"
end

template "#{node['ezproxy']['install_dir']}/config.txt" do
  source 'config.txt.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :ezproxy_name => node['ezproxy']['name']
  )
  action :create
end

cookbook_file "#{node['ezproxy']['install_dir']}/user.txt" do
  source 'user.txt'
  mode '0644'
end

execute 'set up license' do
  cwd node['ezproxy']['install_dir']
  command "#{node['ezproxy']['install_dir']}/#{node['ezproxy']['bin_name']} -k #{node['ezproxy']['license']}"
  not_if { node['ezproxy']['license'].nil? }
end

Chef::Log.warn('Not autostarting ezproxy - this recipe is only for testing!')
