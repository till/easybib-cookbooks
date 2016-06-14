user = if is_aws
         node['nginx-app']['user']
       else
         'vagrant'
       end

applications = if is_aws
                 node['deploy'].keys
               else
                 node['vagrant']['applications'].keys
               end

template '/etc/puma.conf' do
  source 'puma.conf.erb'
  user 'root'
  group 'root'
  mode '0755'
  variables(
    :user => user,
    :apps => applications
  )
end

directory '/var/run/puma' do
  user user
  group user
  mode '0755'
end
