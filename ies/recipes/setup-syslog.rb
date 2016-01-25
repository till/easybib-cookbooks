if node['papertrail']['remote_port'].nil?
  include_recipe 'loggly::setup'
else
  Chef::Log.info("Setting up papertrail: #{node['papertrail']['remote_host']}:#{node['papertrail']['remote_port']}")
  node.set['papertrail']['hostname_name'] = get_record_name
  include_recipe 'papertrail'

  # this can be delete later, previously setup in loggly::setup
  old_files = ['/etc/rsyslog.d/49-loggly.conf', '/etc/rsyslog.d/11-filewatcher.conf']

  old_files.each do |old_file|
    file old_file do
      action :delete
      only_if do
        File.exist?(old_file)
      end
    end
  end
end
