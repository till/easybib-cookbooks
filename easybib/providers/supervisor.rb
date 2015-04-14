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

    supervisor_service service_name do
      action [:enable, :start]
      autostart true
      command service['command']
    end

    Chef::Log.info(
        "easybib_deploy - started supervisor_service #{service_name}")

  end

  new_resource.updated_by_last_action(updated)

end
