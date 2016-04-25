user = if is_aws
         node['nginx-app']['user']
       else
         'vagrant'
       end

template '/etc/puma.conf' do
  source 'puma.conf.erb'
  user 'root'
  group 'root'
  mode '0755'
  variables(
    :apps => node.fetch('puma', {}).fetch('apps', []),
    :user => user
  )
end

directory '/var/run/puma' do
  user user
  group user
  mode '0755'
end
