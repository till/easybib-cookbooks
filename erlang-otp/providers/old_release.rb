# OTP release LWRP provider.

action :deploy do
    service_name = new_resource.name
    root_dir = new_resource.root_dir
    revision = new_resource.revision
    tarballs_dir = "#{root_dir}/_tarballs"
    tarball = "#{tarballs_dir}/#{service_name}-#{revision}.tgz"
    src_root_dir = "#{root_dir}/src"

    # Get app bits to a local tarball.
    # Builds from source in dev mode, otherwise retrieves from S3.
    erlang_otp_release_tarball new_resource.name do
      tarball tarball
      owner new_resource.owner
      group new_resource.group
    end

    # Configure (TODO: consider using the .ini route instead)
    # erlang_otp_service_config new_resource.name do
    #   action :create
    #   revision new_resource.revision
    #   root_dir new_resource.root_dir
    #   etc_dir new_resource.etc_dir
    #   log_dir new_resource.log_dir
    #   sys_config new_resource.sys_config
    #   owner new_resource.owner
    #   group new_resource.group
    #   console_log_count new_resource.console_log_count
    #   console_log_mb new_resource.console_log_mb
    #   error_log_count new_resource.error_log_count
    #   error_log_mb new_resource.error_log_mb
    #   release_type new_resource.release_type
    # end

end

action :restart do
    service_action(:restart, :immediately)
end

action :stop do
    service_action(:stop, :immediately)
end

action :start do
    service_action(:start, :immediately)
end

def service_action(requested_action, requested_timing)
    service_name = new_resource.name
    # This is the simplest way to notify another resource...?
    # A bit convoluted...
    ruby_block "#{requested_action}_#{service_name}" do
        action :create
        block do
            Chef::Log.info("*** otp_service notify #{requested_action}, service[#{service_name}], #{requested_timing}...")
        end
        notifies requested_action, "service[#{service_name}]", requested_timing
    end
end
