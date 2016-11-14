if node['nodejs']['install_repo'] == true && node['platform_family'] == 'debian'
  node.set['nodejs']['keyserver'] = nil

  apt_repository 'node.js' do
    uri node['nodejs']['repo']
    distribution node['lsb']['codename']
    components ['main']
    key 'key.gpg'
  end
end
