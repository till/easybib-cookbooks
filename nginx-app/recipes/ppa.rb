if use_aptly_mirror?
  include_recipe 'aptly::gpg'

  ppa_repo = ppa_mirror(node, node['nginx-app']['ppa'])
  ppa_key  = nil
else
  ppa_repo = node['nginx-app']['ppa']
  ppa_key  = node['nginx-app']['key']
end

apt_repository 'nginx-ppa' do
  uri           ppa_repo
  key           ppa_key
  distribution  node['lsb']['codename']
  components    ['main']
end
