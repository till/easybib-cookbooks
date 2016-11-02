include_recipe 'nginx-amplify::service'

cookbook_file '/usr/bin/nginx-amplify-uuid-helper.py' do
  source 'uuid.py'
  owner 'root'
  group 'root'
  mode 0755
end

template '/etc/amplify-agent/agent.conf' do
  source 'agent.conf.erb'
  mode 0644
  owner 'www-data'
  variables(
    :api_key => node['nginx-amplify']['api_key'],
    :hostname => node['nginx-amplify']['hostname'],
    :uuid => amplify_uuid
  )
  not_if do
    node['nginx-amplify']['api_key'].nil?
  end
  notifies :reload, 'service[amplify-agent]'
end
