include_recipe 'aptly::gpg'

apt_repository 'nodejs-ppa' do
  uri           node['nodejs']['ppa']
  distribution  node['lsb']['codename']
  components    ['main']
end

package 'nodejs'
