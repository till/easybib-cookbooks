config = node['freetds']

package 'freetds-bin' do
  not_if do
    config['server_name'].nil?
  end
end

package 'php5-sybase' do
  not_if do
    node['php']['ppa']['package_prefix'] == 'php5-easybib' || config['server_name'].nil?
  end
end

template '/etc/freetds/freetds.conf' do
  source 'freetds.erb'
  variables(
    :config => config
  )
  not_if do
    config['server_name'].nil?
  end
end
