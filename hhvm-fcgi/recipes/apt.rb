include_recipe 'apt'
include_recipe 'apt::ppa'

easybib_launchpad node['hhvm-fcgi']['boost']['ppa'] do
  action :discover
  only_if do
    node['lsb']['release'].to_f < 14.04
  end
end

apt_repository 'hhvm' do
  uri node['hhvm-fcgi']['apt']['repo']
  distribution node['lsb']['codename']
  components ['main']
  key node['hhvm-fcgi']['apt']['key']
end

apt_package 'install hhvm' do
  package_name "hhvm#{node['hhvm-fcgi']['build']}"
end
