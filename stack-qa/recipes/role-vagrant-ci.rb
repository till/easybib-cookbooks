include_recipe 'easybib::role-generic'
include_recipe 'virtualbox'

node.default['vagrant']['version'] = '1.7.2'
include_recipe 'vagrant'
