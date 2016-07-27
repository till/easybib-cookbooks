include_recipe 'supervisor'

unless is_aws
  conf = node['fake-sqs']

  sqs_bin = '/usr/local/bin/fake_sqs'

  gem_package 'fake_sqs' do
    version conf['version']
  end
  ::Chef::Log.info('SQS - configuring supervisor...')
  supervisor_service 'fake_sqs' do
    action :enable
    autostart true
    command sqs_bin
    user 'nobody'
  end
end
