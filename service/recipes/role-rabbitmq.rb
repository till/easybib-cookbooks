include_recipe 'easybib::setup'

node.set['rabbitmq']['job_control'] = 'upstart' if platform?('ubuntu')

include_recipe 'rabbitmq'
include_recipe 'rabbitmq::mgmt_console'

rabbitmq_user "guest" do
  action :delete
end
