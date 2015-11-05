include_recipe 'apt::ppa'

apt_repository 'easybib-ppa' do
  uri           ::EasyBib::Ppa.ppa_mirror(node, node['apache-couchdb']['ppa'])
  distribution  node['lsb']['codename']
  components    ['main']
end

file '/etc/couchdb/local.ini' do
  action :nothing
end

package 'couchdb' do
  action :install
  notifies :delete, 'file[/etc/couchdb/local.ini]', :immediately
end

include_recipe 'apache-couchdb::service'
include_recipe 'apache-couchdb::configure'
