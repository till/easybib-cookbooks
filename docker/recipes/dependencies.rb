include_recipe "apt::ppa"

if !::File.exists?("/etc/apt/sources.list.d/dotcloud-lxc-docker-#{node["lsb"]["codename"]}.list")
  execute "add #{node["docker"]["ppa"]}" do
    command "add-apt-repository #{node["docker"]["ppa"]}"
  end

  execute "apt-get update"
end

#if is_aws()
#  package "linux-image-extra-#{node["os_version"]}"
#end
