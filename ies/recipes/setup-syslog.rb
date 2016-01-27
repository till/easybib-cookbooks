if node['papertrail']['remote_port'].nil?
  include_recipe 'loggly::setup'
else
  Chef::Log.info("Setting up papertrail: #{node['papertrail']['remote_host']}:#{node['papertrail']['remote_port']}")
  node.set['papertrail']['hostname_name'] = get_record_name

  # configure file watchers
  watch_files = []

  if is_aws && get_instance_roles(node).include?('nginxphpapp')
    watch_files += [
      { :filename => '/var/log/nginx/error.log', :tag => 'nginx' },
      { :filename => '/var/log/php/slow.log', :tag => 'php-fpm' },
      { :filename => '/var/log/php/error.log', :tag => 'php-fpm' },
      { :filename => '/var/log/php/fpm.log', :tag => 'php-fpm' },
      { :filename => '/var/log/supervisor/supervisord.log', :tag => 'supervisor' }
    ]
  end

  if is_aws && get_instance_roles(node).include?('couchdb')
    watch_files += [
      { :filename => '/var/log/couchdb/couch.log', :tag => 'couchdb' }
    ]
  end

  if is_aws && get_instance_roles(node).include?('rabbitmq-server')
    watch_files += [
      { :filename => '/var/log/rabbitmq/startup_log', :tag => 'rabbitmq' },
      { :filename => '/var/log/rabbitmq/startup_err', :tag => 'rabbitmq' },
      { :filename => '/var/log/rabbitmq/shutdown_log', :tag => 'rabbitmq' },
      { :filename => '/var/log/rabbitmq/shutdown_err', :tag => 'rabbitmq' }
    ]
  end

  node.set['papertrail']['watch_files'] = watch_files

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
