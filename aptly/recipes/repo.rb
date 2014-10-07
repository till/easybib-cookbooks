node['aptly']['gpgkeys'].each do |key|
  execute "install-key #{key}" do
    command "apt-key adv --keyserver keyserver.ubuntu.com --recv #{key}"
    action :run
  end
end

apt_repository 'easybib-ppa' do
  only_if      {node["lsb"]["codename"] == "trusty"}
  uri          'http://ppa.ezbib.com/trusty55'
  distribution node['lsb']['codename']
  components   ['main']
end
