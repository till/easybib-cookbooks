# OTP service config LWRP provider. Configures a generic OTP app.
# - etc, log directories linked into app.
# - vm.args, nodetool, erl, start script
# - logrotate (console.log and error.log)
# - rsyslog
# - runit_service

# Where the templates are... There are to be a better way
# than hard-coding it here right?!
OPSCODE_ERLANG = "opscode-erlang"

action :create do
  @run_context.include_recipe "erlang_binary::default"
  @run_context.include_recipe "logrotate::default"
  @run_context.include_recipe "runit"

  std_directory new_resource.log_dir
  std_directory "#{new_resource.log_dir}/sasl"
  in_app_link new_resource.log_dir, "log"

  if new_resource.etc_dir
    std_directory new_resource.etc_dir
    in_app_link new_resource.etc_dir, "etc"
  else
    in_app_directory "etc"
  end

  vm_args_template
  sys_config
  otp_scripts if new_resource.release_type == :reltool
  logrotate_config
  rsyslog_config
  runit_service_config
end

def std_directory(dir)
  directory dir do
    owner new_resource.owner
    group new_resource.group
    mode 0755
    recursive true
  end
end

def in_app_link(source, destination)
  target_file = "#{target_dir}/#{destination}"

  # Sometimes build tarball has these as directories.
  execute "otp_app_#{name}_cleanup_#{destination}" do
    command "rm -Rf #{target_file}"
    only_if "test -d #{target_file}"
  end

  link destination do
    to source
    target_file target_file
    owner new_resource.owner
    group new_resource.group
  end
end

def in_app_directory(dir)
  std_directory "#{target_dir}/#{dir}"
end

def vm_args_template
  template "#{config_location}/vm.args" do
    source "vm.args.erb"
    cookbook OPSCODE_ERLANG
    owner new_resource.owner
    group new_resource.group
    mode 0644
    variables(:app_name => new_resource.name)
    notifies :restart, "service[#{service_name}]", :delayed
  end
end

def sys_config
  template "#{config_location}/sys.config" do
    source "sys.config.erb"
    owner new_resource.owner
    group new_resource.group
    mode 0644
    variables(new_resource.sys_config)
    notifies :restart, "service[#{service_name}]", :delayed
  end
end

def otp_scripts
  # This is the script that will actually run the application.  It is
  # enhanced from the standard Erlang release boot script in that it has
  # support for running under runit.
  std_directory "#{target_dir}/bin"
  template "#{target_dir}/bin/#{new_resource.name}" do
    source "run_script.sh.erb"
    cookbook OPSCODE_ERLANG
    owner new_resource.owner
    group new_resource.group
    mode 0755
    variables(:log_dir => new_resource.log_dir)
    notifies :restart, "service[#{service_name}]", :delayed
  end

  # These are some stock scripts that the boot script needs to call.
  ["nodetool", "erl"].each do |file|
    cookbook_file "#{target_dir}/bin/#{file}" do
      cookbook OPSCODE_ERLANG
      owner new_resource.owner
      group new_resource.group
      mode 0755
    end
  end
end

def logrotate_config
  template "/etc/logrotate.d/#{new_resource.name}" do
    source 'logrotate.erb'
    cookbook OPSCODE_ERLANG
    owner 'root'
    group 'root'
    mode '644'
    variables({
                :console_log_count => new_resource.console_log_count,
                :console_log_mb    => new_resource.console_log_mb,
                :error_log_count   => new_resource.error_log_count,
                :error_log_mb      => new_resource.error_log_mb,
                :log_dir           => new_resource.log_dir,
              })
  end

  # Some services are chatty, so we'll want to be a bit more aggressive
  # running logrotate hourly to ensure that log sizes don't get too big.
  template "/etc/cron.hourly/logrotate" do
    cookbook "logrotate"
    owner "root"
    group "root"
    mode "755"
  end
end

def rsyslog_config
  # Drop off an rsyslog configuration
  template "/etc/rsyslog.d/30-#{name}.conf" do
    source "erlang_app_rsyslog.conf.erb"
    cookbook OPSCODE_ERLANG
    owner "root"
    group "root"
    mode 0644
    variables(:app_name => new_resource.name,
              :log_file_path => "/var/log/#{name}.log")
    notifies :restart, "service[rsyslog]"
  end
end

def runit_service_config
  service_opts = {
    :srv_dir => target_dir,
    :bin_name => name,
    :app_name => name,
    :runit_script_verb => runit_script_verb,
    # These are for the run script
    :run_setuidgid => owner,
    :run_envuidgid => group,

    # This is for the log-run script
    :log_setuidgid => "nobody"
  }
  runit_service service_name do
    template_name "erlang_app" # Our common template
    # resolves to our sv-erlang_app-run.erb
    # and sv-erlang_app-log-run.erb
    cookbook OPSCODE_ERLANG
    options service_opts
  end
end

def runit_script_verb
  case new_resource.release_type
  when :reltool
    "runit"
  when :relx
    "foreground"
  end
end

def name
  new_resource.name
end

def revision
  new_resource.revision
end

def owner
  new_resource.owner
end

def group
  new_resource.group
end

def target_dir
  "#{app_releases_dir}/#{revision}/#{name}"
end

def app_releases_dir
  "#{releases_dir}/#{name}"
end

def releases_dir
  "#{new_resource.root_dir}/_releases"
end

def config_location
  case new_resource.release_type
  when :reltool
    "#{target_dir}/etc"
  when :relx
    "#{target_dir}"
  end
end

def service_name
  new_resource.name
end
