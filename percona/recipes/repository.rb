apt_repository 'percona' do
  uri          'http://repo.percona.com/apt'
  arch         'amd64'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    node['percona']['keyserver']
  key          node['percona']['key']
end
