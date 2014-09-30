node['nodejs']['directories'].each do |dir|
  directory "#{node['opsworks']['deploy_user']['home']}/#{dir}" do
    user node['opsworks']['deploy_user']['user']
    group node['opsworks']['deploy_user']['group']
    mode 0755
    not_if do
      node['opsworks']['deploy_user'].nil?
    end
  end
end
