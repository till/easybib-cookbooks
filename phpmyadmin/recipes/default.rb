include_recipe 'aptly::gpg'

apt_repository 'phpmyadmin-ppa' do
  uri           'ppa:nijel/phpmyadmin'
  distribution  node['php55']['ppa']
end

package 'phpmyadmin'
