action :install do
  destination = new_resource.destination
  artifact = new_resource.artifact
  reboot = new_resource.reboot

  # Parse out name & version

  erlang_otp_release_tarball do
    tarball artifact
    name name
    version version
  end

  # execute install

  # optionally reboot

end

action :deploy do
  @run_context.include_recipe 'erlang_binary::default'

  service_name = new_resource.name
  root_dir = new_resource.root_dir
  revision = new_resource.revision
  tarballs_dir = "#{root_dir}/_tarballs"
  tarball = "#{tarballs_dir}/#{service_name}-#{revision}.tgz"
  src_root_dir = "#{root_dir}/src"

  # Get app bits to a local tarball.
  # Builds from source in dev mode, otherwise retrieves from S3.
  opscode_erlang_otp_release_artifact new_resource.name do
    tarball tarball
    development_mode new_resource.development_mode
    source new_resource.source
    revision new_resource.revision
    force_clean_src new_resource.force_clean_src
    aws_bucket new_resource.aws_bucket
    aws_access_key_id new_resource.aws_access_key_id
    aws_secret_access_key new_resource.aws_secret_access_key
    owner new_resource.owner
    group new_resource.group
    src_root_dir src_root_dir
  end

  # We have a tarball. Now deploy it.
  # (Includes hipchat notification.)
  opscode_erlang_service_pkg new_resource.name do
    action :deploy
    revision new_resource.revision
    tarball tarball
    root_dir new_resource.root_dir
    owner new_resource.owner
    group new_resource.group
    force_deploy new_resource.force_deploy || new_resource.development_mode
    app_environment new_resource.app_environment
    estatsd_host new_resource.estatsd_host
    hipchat_key new_resource.hipchat_key
    notifies :delayed_restart, "opscode-erlang_otp_service[#{new_resource.name}]", :immediately
  end

  # Configure
  opscode_erlang_otp_service_config new_resource.name do
    action :create
    revision new_resource.revision
    root_dir new_resource.root_dir
    etc_dir new_resource.etc_dir
    log_dir new_resource.log_dir
    sys_config new_resource.sys_config
    owner new_resource.owner
    group new_resource.group
    console_log_count new_resource.console_log_count
    console_log_mb new_resource.console_log_mb
    error_log_count new_resource.error_log_count
    error_log_mb new_resource.error_log_mb
    release_type new_resource.release_type
  end
end

action :delayed_restart do
  service_action(:restart, :delayed)
end

action :immediate_restart do
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
