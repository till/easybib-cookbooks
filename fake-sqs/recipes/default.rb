include_recipe 'supervisor'

unless is_aws
  ::Chef::Log.info('SQS - installing fake_sqs...')
  gem_package 'fake_sqs' do
    version conf['version']
  end
  ::Chef::Log.info('SQS - configuring supervisor...')
  supervisor_service 'fake_sqs' do
    action :enable
    autostart true
    command '/usr/local/bin/fake_sqs'
    user 'nobody'
  end
end
