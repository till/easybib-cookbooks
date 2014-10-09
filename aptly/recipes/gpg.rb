node['aptly']['gpgkeys'].each do |key|
  execute "install-key #{key}" do
    command "apt-key adv --keyserver keyserver.ubuntu.com --recv #{key}"
    only_if { node['lsb']['codename'] == 'trusty' && node['apt']['enable_trusty_mirror'] }
    action :run
  end
end
