include_recipe 'apt::ppa'

apt_repository 'phpmyadmin-ppa' do
  uri           'ppa:nijel/phpmyadmin'
  distribution  node['lsb']['codename']
end

package 'phpmyadmin'
