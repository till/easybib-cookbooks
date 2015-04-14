action :create do
  app = new_resource.app
  supervisor_file = new_resource.supervisor_file

  updated = false

  unless ::File.exist?(supervisor_file)
    new_resource.updated_by_last_action(updated)
    next
  end

  Chef::Log.info(
      "easybib_deploy - loading supervisor services from #{supervisor_file}")

  supervisor_config = JSON.parse(::File.read(supervisor_file))

  supervisor_config.each do |name, service|
    updated = true

    service_name = "#{name}-#{app}"

    Chef::Log.info(
        "easybib_deploy - enabling supervisor_service #{service_name}")

    config = {
      'numprocs' => 1,
      'numprocs_start' => 0,
      'priority' => 999,
      'autostart' => true,
      'startsecs' => 1,
      'startretries' => 3,
      'exitcodes' => [0, 2],
      'stopasgroup' => nil,
      'killasgroup' => nil,
      'user' => nil,
      'redirect_stderr' => false,
      'stdout_logfile' => 'AUTO',
      'stdout_logfile_maxbytes' => '50MB',
      'stdout_logfile_backups' => 10,
      'stdout_capture_maxbytes' => '0',
      'stdout_events_enabled' => false,
      'stderr_logfile' => 'AUTO',
      'stderr_logfile_maxbytes' => '50MB',
      'stderr_logfile_backups' => 10,
      'stderr_capture_maxbytes' => '0',
      'stderr_events_enabled' => false,
      'environment' => {},
      'directory' => nil,
      'umask' => nil,
      'serverurl' => 'AUTO'
    }

    config.merge!(service)

    supervisor_service service_name do
      action [:enable, :start]
      autostart true
      command config['command']
      numprocs config['numprocs']
      numprocs_start config['numprocs_start']
      priority config['priority']
      autostart config['autostart']
      startsecs config['startsecs']
      startretries config['startretries']
      exitcodes config['exitcodes']
      stopasgroup config['stopasgroup']
      killasgroup config['killasgroup']
      user config['user']
      redirect_stderr config['redirect_stderr']
      stdout_logfile config['stdout_logfile']
      stdout_logfile_maxbytes config['stdout_logfile_maxbytes']
      stdout_logfile_backups config['stdout_logfile_backups']
      stdout_capture_maxbytes config['stdout_capture_maxbytes']
      stdout_events_enabled config['stdout_events_enabled']
      stderr_logfile config['stderr_logfile']
      stderr_logfile_maxbytes config['stderr_logfile_maxbytes']
      stderr_logfile_backups config['stderr_logfile_backups']
      stderr_capture_maxbytes config['stderr_capture_maxbytes']
      stderr_events_enabled config['stderr_events_enabled']
      environment config['environment']
      directory config['directory']
      umask config['umask']
      serverurl config['serverurl']
    end

    Chef::Log.info(
        "easybib_deploy - started supervisor_service #{service_name}")

  end

  new_resource.updated_by_last_action(updated)

end
