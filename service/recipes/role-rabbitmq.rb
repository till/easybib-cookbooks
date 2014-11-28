include_recipe 'easybib::setup'

node.set['rabbitmq']['job_control'] = 'upstart' if platform?('ubuntu')
node.set['rabbitmq']['disabled_users'] = ['guest'] if is_aws

include_recipe 'rabbitmq'
include_recipe 'rabbitmq::mgmt_console'
