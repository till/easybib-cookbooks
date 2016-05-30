include_recipe 'ies::role-generic'

# Rotate RabbitMQ logs in /mnt/logs/rabbitmq.
# See: https://imagineeasy.atlassian.net/browse/DEVOPS-150
include_recipe 'logrotate::global'

node.set['rabbitmq']['job_control'] = 'upstart' if platform?('ubuntu')

include_recipe 'rabbitmq'
include_recipe 'rabbitmq::mgmt_console'

rabbitmq_user 'guest' do
  action :delete
end

include_recipe 'rabbitmq::virtualhost_management'
include_recipe 'rabbitmq::user_management'

if node['rabbitmq']['logdir'].nil?
  Chef::Log.debug('Standard log dir not set, no need to mangle.')
  return
end

std_log_dir = '/var/log/rabbitmq'

# clean-up and re-direct
directory std_log_dir do
  recursive true
  action :delete
  only_if do
    node['rabbitmq']['logdir'] != std_log_dir
  end
end

link std_log_dir do
  to node['rabbitmq']['logdir']
  only_if do
    node['rabbitmq']['logdir'] != std_log_dir
  end
end
