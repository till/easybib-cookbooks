include_recipe 'apt::ppa'

sources_file = "/etc/apt/sources.list.d/#{node['ruby-brightbox']['ppa'].split(':')[1].gsub('/', '-')}.list"

apt_repository 'ruby-brightbox' do
  not_if do
    File.exist?(sources_file)
  end
  distribution  node['lsb']['codename']
  uri           node['ruby-brightbox']['ppa']
end

package "ruby#{node['ruby-brightbox']['version']}"
