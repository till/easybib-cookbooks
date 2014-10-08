apt_repository 'easybib-ppa' do
  uri           node['apt']['easybib']['ppa']
  distribution  node['lsb']['codename']
end
