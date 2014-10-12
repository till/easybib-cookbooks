node['aptly']['gpgkeys'].each do |key|
  execute "install-key #{key}" do
    command "apt-key adv --keyserver keyserver.ubuntu.com --recv #{key}"
    only_if { ::EasyBib.use_aptly_mirror?(node) }
    action :run
  end
end
