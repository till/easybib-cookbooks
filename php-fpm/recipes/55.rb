include_recipe 'apt::ppa'
include_recipe 'apt::easybib'

apt_repository "easiybib-ppa" do
  uri node['apt']['easybib']['ppa-php55'] 
end
