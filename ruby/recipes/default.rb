include_recipe "apt::ppa"

execute "refresh-apt-cache" do
  command "apt-get update"
  action :nothing
end

sources_file = "/etc/apt/sources.list.d/#{node["ruby"]["ppa"].split(':')[1].gsub("/", "-")}.list"

execute "discover ppa" do
  command "add-apt-repository #{node["ruby"]["ppa"]}"
  notifies :run, "execute[refresh-apt-cache]", :immediately
  only_if do
    !File.exists?(sources_file)
  end
end

package "ruby#{node["ruby"]["version"]}"
