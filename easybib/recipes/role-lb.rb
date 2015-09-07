include_recipe 'easybib::setup'
include_recipe 'loggly::setup'
include_recipe 'rsyslogd::mute-cron'

include_recipe 'haproxy::ctl'
include_recipe 'haproxy::hatop'
include_recipe 'haproxy::logs'

# haproxy::default and haproxy::configure are being executed/specified in the opsworks
# recipe list, no need to have them here

package "ngrep"

if (node['haproxy']['type'] == '1.5')
  # haproxy does ssl if needed, just install certificates
  include_recipe 'easybib-deploy::ssl-certificates'
else
  # our default haproxy version is 1.4, without ssl support
  # so install nginx as ssl wrapper
  include_recipe 'nginx-lb'
  include_recipe 'easybib-deploy::ssl'
end
