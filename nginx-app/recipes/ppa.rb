include_recipe 'aptly::gpg'

apt_repository 'nginx-ppa' do
  uri           ::EasyBib::Ppa.ppa_mirror(node, node['nginx-app']['ppa'])
  distribution  node['lsb']['codename']
  components    ['main']
end
