include_recipe 'apt'
include_recipe 'aptly::gpg'

apt_repository 'boost-ppa' do
  uri node['hhvm-fcgi']['boost']['ppa']
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
