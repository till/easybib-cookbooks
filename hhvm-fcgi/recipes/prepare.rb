directories = [
  node['hhvm-fcgi']['tmpdir'],
  File.dirname(node['hhvm-fcgi']['logfile'])
]

directories.each do |dir|
  directory dir do
    mode '0755'
    owner node['hhvm-fcgi']['user']
    group node['hhvm-fcgi']['group']
  end
end

file node['hhvm-fcgi']['logfile'] do
  mode '0755'
  owner node['hhvm-fcgi']['user']
  group node['hhvm-fcgi']['group']
end

template '/etc/init.d/hhvm' do
  mode   '0755'
  source 'init.d.hhvm.erb'
  owner  node['hhvm-fcgi']['user']
  group  node['hhvm-fcgi']['group']
end
