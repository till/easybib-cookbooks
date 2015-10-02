base_packages = [
  'htop', 'jwhois', 'multitail',
  'apache2-utils', 'strace', 'rsync',
  'manpages', 'manpages-dev',
  'git-core', 'unzip', 'realpath', 'curl'
]

apt_package base_packages

chef_gem 'Remove: BibOpsworks' do
  package_name 'BibOpsworks'
  action :remove
  only_if do
    ::EasyBib.is_aws(node)
  end
  ignore_failure true
end

chef_gem 'Update: BibOpsworks' do
  package_name 'BibOpsworks'
  action :upgrade
  only_if do
    ::EasyBib.is_aws(node)
  end
end

include_recipe 'easybib::nscd'
include_recipe 'easybib::nginxstats'
include_recipe 'easybib::cron'
include_recipe 'easybib::ruby'
include_recipe 'easybib::profile'

if is_aws
  if node['opsworks']['activity'] == 'setup'
    ::EasyBib::SNS.sns_notify_spinup(node)
  end

  include_recipe 'fail2ban'
  if node.attribute?('chef_handler_sns') &&
     node['chef_handler_sns'].attribute?('topic_arn') &&
     !node['chef_handler_sns']['topic_arn'].nil?
    include_recipe 'chef_handler_sns::default'
  end
  include_recipe 'easybib::opsworks-fixes'
  include_recipe 'apt::unattended-upgrades'
end

remove_packages = [
  'landscape-client', # https://bugs.launchpad.net/ubuntu/+source/pam/+bug/805423
  'ganglia-monitor', # opsworks installs this but we don't need it
  'libganglia1'
]

package remove_packages do
  action :purge
end
