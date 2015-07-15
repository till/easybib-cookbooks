include_recipe 'apt::ppa'
include_recipe 'aptly::gpg'

apt_repository 'easybib-ppa' do
  uri           ::EasyBib::Ppa.ppa_mirror(node)
  distribution  node['lsb']['codename']
  components    ['main']
end
