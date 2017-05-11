include_recipe 'supervisor'

unless is_aws
  conf = node['fake-sqs']

  sqs_bin = '/usr/local/bin/fake_sqs'

  sqs_deps = {'builder' => '3.2.2', 'sinatra' => '1.4.8'}
  sqs_deps.each do |sqs_dep,sqs_dep_version|
    gem_package sqs_dep do
      version sqs_dep_version
      options '--conservative'
    end
  end

  gem_package 'fake_sqs' do
    version conf['version']
    options '--conservative'
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
