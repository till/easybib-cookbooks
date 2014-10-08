include_recipe 'aptly::gpg'

apt_repository "easiybib-ppa" do
  uri           node['nodejs']['ppa']
  distribution  node['lsb']['codename']
end

package 'nodejs'
