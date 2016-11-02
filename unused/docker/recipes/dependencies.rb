include_recipe 'ies-apt::ppa'

apt_repository 'docker' do
  not_if do
    ::File.exist?("/etc/apt/sources.list.d/dotcloud-lxc-docker-#{node['lsb']['codename']}.list")
  end
  distribution  node['lsb']['codename']
  uri           node['docker']['ppa']
end

# if is_aws()
#  package "linux-image-extra-#{node["os_version"]}"
# end
