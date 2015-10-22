include_recipe 'ies::role-generic'

node.set['rabbitmq']['job_control'] = 'upstart' if platform?('ubuntu')

include_recipe 'rabbitmq'
include_recipe 'rabbitmq::mgmt_console'

rabbitmq_user 'guest' do
  action :delete
end

include_recipe 'rabbitmq::virtualhost_management'
include_recipe 'rabbitmq::user_management'
