include_recipe 'apt::ppa'

easybib_launchpad node['docker']['ppa'] do
  action :discover
  not_if do
    ::File.exist?("/etc/apt/sources.list.d/dotcloud-lxc-docker-#{node['lsb']['codename']}.list")
  end
end

# if is_aws()
#  package "linux-image-extra-#{node["os_version"]}"
# end
