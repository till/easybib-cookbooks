include_recipe 'apt::ppa'
include_recipe 'aptly::gpg'

apt_repository 'easybib-ppa' do
  uri           ::EasyBib.ppa_mirror(node, node['apt']['easybib']['ppa'])
  distribution  node['lsb']['codename']
  components    ['main']
end
