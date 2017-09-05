include_recipe 'ies::role-generic'

include_recipe 'haproxy::ctl'
include_recipe 'haproxy::hatop'
include_recipe 'haproxy::logs'

# haproxy::default and haproxy::configure are being executed/specified in the opsworks
# recipe list, no need to have them here

node.normal['scout']['hostname'] = get_hostname(node)

include_recipe 'scout'

package 'ngrep'

include_recipe 'ies-ssl::deploy-ssl-certificates'
