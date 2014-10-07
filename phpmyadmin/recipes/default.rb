include_recipe 'apt::ppa'

apt_repository 'phpmyadmin-ppa' do
  uri    'ppa:nijel/phpmyadmin'
end

package 'phpmyadmin'
