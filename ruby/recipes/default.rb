include_recipe "apt::ppa"

sources_file = "/etc/apt/sources.list.d/#{node["ruby"]["ppa"].split(':')[1].gsub("/", "-")}.list"

easybib_launchpad node["ruby"]["ppa"] do
  not_if do
    File.exists?(sources_file)
  end
end

package "ruby#{node["ruby"]["version"]}"
