include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "rsyslogd::mute-cron"
include_recipe "nginx-app::server"
