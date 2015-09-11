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

def send_spinup_notification
  if !get_cluster_name.empty?
    instance    = get_instance
    my_hostname = instance['hostname']
  else
    # node.json
    if node['server_name']
      my_hostname = node['server_name']
    # from 'ohai'
    else
      my_hostname = node['hostname']
    end
  end

  if my_hostname.nil?
    Chef::Log.error 'can not determine hostname of this node!'
    return
  end

  if my_hostname.include?('-load')
    sns_message = "subject: SPIN-UP notification of #{my_hostname}

    The node #{my_hostname} has gone into deployment phase and will be booted shortly after.

    Sincerely yours,
    EasyBib SNS Library
    "
  end
end

if is_aws
  send_spinup_notification

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
