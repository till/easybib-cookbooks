home_dir = "/home/#{node['tsung']['user']}"
tsung_dir = "#{home_dir}/.tsung"
log_dir = "#{tsung_dir}/log"

directory log_dir do
  owner node['tsung']['user']
  mode '0755'
  action :create
  recursive true
end

template '/etc/nginx/sites-available/tsung' do
  source 'tsung.host.erb'
  mode '0644'
  owner node['nginx-app']['user']
  group node['nginx-app']['group']
  action :create
  variables(
    :access_log => node['tsung']['nginx']['access_log'],
    :port => node['tsung']['nginx']['port'],
    :root => log_dir
  )
  notifies :enable, 'service[nginx]', :immediately
  notifies :reload, 'service[nginx]', :delayed
end

# scenario
template "#{tsung_dir}/tsung.xml" do
  source 'tsung.xml.erb'
  owner node['tsung']['user']
end

cookbook_file "#{tsung_dir}/listids.csv" do
  source 'listids.csv'
  mode '0644'
  owner node['tsung']['user']
  action :create
end
