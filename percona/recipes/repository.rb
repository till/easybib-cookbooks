apt_repository 'percona' do
  uri          'http://repo.percona.com/apt'
  arch         'amd64'
  distribution node['lsb']['codename']
  components   ['main']
  keyserver    'keys.gnupg.net'
  key          '1C4CBDCDCD2EFD2A'
end
