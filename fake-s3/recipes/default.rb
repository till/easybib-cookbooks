include_recipe 'supervisor'

unless is_aws
  conf = node['fake-s3']

  gem_package 'fakes3' do
    version conf['version']
  end

  supervisor_service 'fakes3' do
    action :enable
    autostart true
    command "/usr/local/bin/fakes3 -r #{conf['storage']} -p #{conf['port']}"
    user 'nobody'
  end
end
