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
