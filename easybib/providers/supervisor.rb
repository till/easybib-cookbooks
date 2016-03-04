action :create do
  app = new_resource.app
  app_dir = new_resource.app_dir
  supervisor_file = new_resource.supervisor_file
  supervisor_role = new_resource.supervisor_role
  instance_roles = new_resource.instance_roles
  user = new_resource.user
  instance_roles = get_instance_roles(node) if instance_roles.empty?
  supervisor_role = node['easybib_deploy']['supervisor_role'] if supervisor_role.nil?

  updated = false

  unless ::File.exist?(supervisor_file)
    new_resource.updated_by_last_action(updated)
    next
  end

  # do always deploy supervisor in vagrant, ignore roles, so default to true
  deploy_supervisor = true
  if is_aws(node)
    # but if we are in aws, decide upon the roles of the instance
    deploy_supervisor = has_role?(instance_roles, supervisor_role)
  end

  unless deploy_supervisor
    Chef::Log.info("easybib_supervisor - I did not install supervisor because instance does not have the #{supervisor_role} role in roles: #{instance_roles}")
    new_resource.updated_by_last_action(updated)
    next
  end

  Chef::Log.info(
    "easybib_supervisor - loading supervisor services from #{supervisor_file}")

  supervisor_config = JSON.parse(::File.read(supervisor_file))

  search_path = "/etc/supervisor.d/*-#{app}.conf"
  Chef::Log.info("WIP easybib_supervisor - searching for conf in #{search_path}")
  conf_files = []
  Dir.glob(search_path).each do|file|
    conf_files.push(file.split('/').last)
  end

  supervisor_config.each do |name, service|
    updated = true

    service_name = "#{name}-#{app}"

    Chef::Log.info(
      "easybib_supervisor - enabling supervisor_service #{service_name}")

    config = build_supervisor_config(service, user)

    supervisor_service service_name do
      action [:enable, :restart]
      autostart true
      command "#{app_dir}/#{config['command']}"
      numprocs config['numprocs']
      numprocs_start config['numprocs_start']
      process_name config['process_name']
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

    Chef::Log.info("easybib_supervisor - started supervisor_service #{service_name}")
    conf_files.delete("#{service_name}.conf")
  end

  conf_files.each do|file|
    Chef::Log.info("WIP easybib_supervisor - found supervisor conf file #{file}")
  end

  new_resource.updated_by_last_action(updated)

end

action :delete do
  app = new_resource.app
  # get the deploy data
  deploy_data = new_resource.deploy_data
  # divine the suervisor configuration location
  supervisor_file = "#{deploy_data['deploy_to']}/current/deploy/supervisor.json"
  app_dir = "#{deploy_data['deploy_to']}/current"

  user = new_resource.user

  # unless supervisor_file exists
  unless ::File.exist?(supervisor_file)
    new_resource.updated_by_last_action(true)
    next
  end

  supervisor_config = JSON.parse(::File.read(supervisor_file))

  supervisor_config.each do |name, service|
    service_name = "#{name}-#{app}"
    Chef::Log.info(
      "easybib_supervisor - DISABLING supervisor_service #{service_name}")

    config = build_supervisor_config(service, user)

    Chef::Log.info(
      "easybib_supervisor - #{app_dir}/#{config['command']}")

    supervisor_service service_name do
      action [:stop, :disable]
      autostart true
      command "#{app_dir}/#{config['command']}"
      numprocs config['numprocs']
      numprocs_start config['numprocs_start']
      process_name config['process_name']
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
      "easybib_supervisor - started supervisor_service #{service_name}")

  end

  new_resource.updated_by_last_action(true)
end

def build_supervisor_config(service_config, user)
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
    'user' => user,
    'redirect_stderr' => false,
    'stdout_logfile' => 'syslog',
    'stdout_logfile_maxbytes' => '50MB',
    'stdout_logfile_backups' => 10,
    'stdout_capture_maxbytes' => '0',
    'stdout_events_enabled' => false,
    'stderr_logfile' => 'syslog',
    'stderr_logfile_maxbytes' => '50MB',
    'stderr_logfile_backups' => 10,
    'stderr_capture_maxbytes' => '0',
    'stderr_events_enabled' => false,
    'environment' => {},
    'directory' => nil,
    'umask' => nil,
    'serverurl' => 'AUTO',
    'process_name' => '%(program_name)s'
  }

  config.merge!(service_config)
end
