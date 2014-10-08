include_recipe 'apt::ppa'

apt_repository "easiybib-ppa" do
  uri           'ppa:chris-lea/node.js-devel'
  distribution  node['lsb']['codename']
end

package 'nodejs'
