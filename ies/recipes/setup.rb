base_packages = [
  'htop', 'jwhois', 'multitail',
  'apache2-utils', 'strace', 'rsync',
  'manpages', 'manpages-dev',
  'git-core', 'unzip', 'realpath', 'curl'
]

base_packages.each do |p|
  package p
end

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
  include_recipe 'ies::setup-sns'
  include_recipe 'fail2ban'
  include_recipe 'easybib::opsworks-fixes'
  include_recipe 'apt::unattended-upgrades'
end

# landscape is buggy
# https://bugs.launchpad.net/ubuntu/+source/pam/+bug/805423
package 'landscape-client' do
  action :purge
end

# opsworks installs this but we don't need it
['ganglia-monitor', 'libganglia1'].each do |p|
  package p do
    action :purge
  end
end

include_recipe 'loggly::setup'
