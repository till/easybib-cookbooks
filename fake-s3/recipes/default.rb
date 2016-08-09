include_recipe 'supervisor'

unless is_aws
  conf = node['fake-s3']

  s3_bin = '/usr/local/bin/fakes3'

  gem_package 'fakes3' do
    version conf['version']
  end

  # installed chef inside vagrant box demands this
  link s3_bin do
    to '/opt/chef/embedded/bin/fakes3'
    only_if { File.exist?('/opt/chef/embedded/bin/fakes3') }
  end

  supervisor_service 'fakes3' do
    action :enable
    autostart true
    command "#{s3_bin} -r #{conf['storage']} -p #{conf['port']}"
    user 'nobody'
  end
end
