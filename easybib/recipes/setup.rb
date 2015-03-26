base_packages = [
  'htop', 'jwhois', 'multitail',
  'apache2-utils', 'strace', 'rsync',
  'manpages', 'manpages-dev',
  'git-core', 'unzip', 'realpath', 'curl'
]

base_packages.each do |p|
  package p
end

chef_gem 'BibOpsworks' do
  options('--clear-sources http://rubygems.org/')
  action :install
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
  include_recipe 'fail2ban'
  if node.attribute?('chef_handler_sns') &&
     node['chef_handler_sns'].attribute?('topic_arn') &&
     !node['chef_handler_sns']['topic_arn'].nil?
    include_recipe 'chef_handler_sns::default'
  end
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
