include_recipe 'apt::ppa'

apt_repository 'easybib-ppa' do
  uri           ::EasyBib.ppa_mirror(node, node['apt']['easybib']['ppa'])
  distribution  node['lsb']['codename']
end
