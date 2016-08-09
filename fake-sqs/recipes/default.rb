include_recipe 'supervisor'

unless is_aws
  conf = node['fake-sqs']

  sqs_bin = '/usr/local/bin/fake_sqs'

  gem_package 'fake_sqs' do
    version conf['version']
  end

  # installed chef inside vagrant box demands this
  link sqs_bin do
    to '/opt/chef/embedded/bin/fake_sqs'
    only_if { File.exist?('/opt/chef/embedded/bin/fake_sqs') }
  end

  supervisor_service 'fake_sqs' do
    action :enable
    autostart true
    command sqs_bin
    user 'nobody'
  end
end
