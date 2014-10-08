include_recipe 'aptly::gpg'

apt_repository 'easiybib-ppa' do
  uri           node['php55']['ppa']
  distribution  node['lsb']['codename']
end
