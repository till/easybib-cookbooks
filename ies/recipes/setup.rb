include_recipe 'ies::setup-basepackages'
include_recipe 'ies::setup-bibopsworks' if is_aws
include_recipe 'easybib::nscd'
include_recipe 'easybib::nginxstats'
include_recipe 'easybib::cron'
include_recipe 'easybib::ruby'
include_recipe 'easybib::profile'

if is_aws
  include_recipe 'ies::setup-sns'
  include_recipe 'fail2ban'
  include_recipe 'easybib::opsworks-fixes'
  include_recipe 'apt::unattended-upgrades'
end

include_recipe 'loggly::setup'
