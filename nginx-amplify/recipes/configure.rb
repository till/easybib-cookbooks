include_recipe 'nginx-amplify::service'

template '/etc/amplify-agent/agent.conf' do
  source 'agent.conf.erb'
  mode 0644
  owner 'www-data'
  variables(
    :api_key => node['nginx-amplify']['api_key'],
    :hostname => node['nginx-amplify']['hostname'],
    :uuid => nil
  )
  not_if do
    node['nginx-amplify']['api_key'].nil?
  end
  notifies :reload, 'service[amplify-agent]'
end
