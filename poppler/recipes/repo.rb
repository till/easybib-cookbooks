apt_repository 'poppler' do
  uri          node['poppler']['package_uri']
  arch         node['poppler']['package_arch']
  distribution node['poppler']['package_distro']
  components   node['poppler']['package_components']
  key          node['poppler']['package_key_uri']
end
