node['aptly']['gpgkeys'].each do |key|
  cache_file = "#{Chef::Config[:file_cache_path]}/#{key}.gpg"

  cookbook_file cache_file do
    source "#{key}.gpg"
    cookbook 'aptly'
    mode 00644
    action :create
  end

  execute "install-key #{key}" do
    command "apt-key add #{cache_file}"
    only_if { ::EasyBib::Ppa.use_aptly_mirror?(node) }
    action :run
  end
end
