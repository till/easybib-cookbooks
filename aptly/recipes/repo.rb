node['aptly']['gpgkeys'].each do |key|
  execute "install-key #{key}" do
    command "apt-key adv --keyserver keyserver.ubuntu.com --recv #{key}"
    action :run
  end
end

apt_repository 'easybib-ppa' do
  uri          'http://ppa.ezbib.com'
  distribution node['lsb']['codename']
  components   ['main']
end