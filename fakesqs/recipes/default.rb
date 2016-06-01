include_recipe 'ruby-brightbox'

unless is_aws
  ::Chef::Log.info('SQS - installing fake_sqs...')
  gem_package 'fake_sqs' do
    version '0.3.1'
  end
  ::Chef::Log.info('SQS - configuring supervisor...')
  supervisor_service 'fake_sqs' do
    action :enable
    autostart true
    command '/usr/local/bin/fake_sqs'
    user 'nobody'
  end
end
