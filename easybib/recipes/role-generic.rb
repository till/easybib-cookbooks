include_recipe 'ies::setup'
include_recipe 'loggly::setup'
include_recipe 'rsyslogd::mute-cron'
include_recipe 'nginx-app::server'
include_recipe 'postfix' if is_aws
