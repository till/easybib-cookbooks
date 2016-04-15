include_recipe 'ies-apt::ppa'
include_recipe 'aptly::gpg'

apt_repository 'ondrejphp-ppa' do
  uri           'ppa:ondrej/php' # FIXME: this needs to be reverted
  distribution  node['lsb']['codename']
  components    ['main']
end
