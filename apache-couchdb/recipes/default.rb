include_recipe 'apt::ppa'

apt_repository 'easybib-ppa' do
  uri           ::EasyBib::Ppa.ppa_mirror(node, node['apache-couchdb']['ppa'])
  distribution  node['lsb']['codename']
  components    ['main']
end

package 'couchdb' do
  action :install
  notifies :start, 'service[couchdb]', :immediately
end

include_recipe 'apache-couchdb::service'
include_recipe 'apache-couchdb::configure'
