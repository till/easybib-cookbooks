include_recipe 'ohai'
include_recipe 'supervisor'

include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'

include_recipe 'fake-sqs'

node.set['fake-s3']['storage'] = '/vagrant_wpt/var/s3'
include_recipe 'fake-s3'

# frontend
# include_recipe 'nodejs'
# include_recipe 'nodejs::npm'
# package 'build-essential'
# package 'g++'

include_recipe 'stack-scholar::role-scholar'
include_recipe 'php::module-pdo_sqlite'
include_recipe 'nginx-app::vagrant-silex'

apt_repository 'libreoffice-5.2' do
  uri 'ppa:libreoffice/libreoffice-5-2'
  key 'libreoffice-5.2.key'
  distribution node['lsb']['codename']
  components ['main']
end

apt_package 'libreoffice' do
  action :install
  options '--no-install-recommends --no-install-suggests'
end
