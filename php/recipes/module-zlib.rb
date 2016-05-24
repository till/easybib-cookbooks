include_recipe 'php::dependencies-ppa'

php_ppa_package 'zlib' do
  only_if do
    node['php']['ppa']['package_prefix'] == 'php5-easybib'
  end
end
