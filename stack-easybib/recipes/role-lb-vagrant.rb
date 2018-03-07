include_recipe 'ies::role-generic'

# This is a duplicate of role-lb.rb with only haproxy::default and haproxy::configure
# added because these are automatically executed by opsworks.
include_recipe 'haproxy::default'
include_recipe 'haproxy::configure'

include_recipe 'haproxy::ctl'
include_recipe 'haproxy::hatop'
include_recipe 'haproxy::logs'

# haproxy::default and haproxy::configure are being executed/specified in the opsworks
# recipe list, no need to have them here

include_recipe 'ies-datadog::default'

package 'ngrep'

include_recipe 'ies-ssl::deploy-ssl-certificates'
