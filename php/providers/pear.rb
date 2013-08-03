def initialize(*args)
  super(*args)

  pear = pear_run("which pear").strip

  if pear.empty?
    raise Chef::Exceptions::ShellCommandFailed, "PEAR is not installed, or not in the path."
  end

  @pear_cmd = pear

  Chef::Log.debug("Looks like we found a PEAR installer: #{@pear_cmd}")
  pear_run("#{@pear_cmd} config-set auto_discover 1")
  Chef::Log.debug("Enabled auto_discover")

end

def pear_run(cmd)
  cmd = Mixlib::ShellOut.new(cmd)
  out = cmd.run_command.stdout.strip
  #Chef::Log.debug("Command '#{cmd.command}' ran with exit status: #{cmd.exitstatus}")
  #Chef::Log.debug("StdOut: #{cmd.stdout}")
  #Chef::Log.debug("StdErr: #{cmd.stderr}")

  if cmd.exitstatus > 0
    raise "Failed: #{cmd.command}, StdOut: #{cmd.stdout}, StdErr: #{cmd.stderr}"
  end

  return out
end

def discovered?(pear, channel)
  command = "#{pear} channel-info #{channel}"
  cmd     = Mixlib::ShellOut.new(command)

  cmd.run_command

  if cmd.exitstatus > 0
    return false
  else
    return true
  end

end

def pear_cmd(pear, action, package, force, channel, version)

  if not discovered?(pear, channel)
    discover = Mixlib::ShellOut.new("#{pear} channel-discover #{channel}")
    discover.run_command
  end

  # get the alias - BUT Y U NEED ALIAS?! - because when the channel is 'foo.example.org/pear' it screws up pear install
  command_alias = "#{pear} channel-info #{channel}|grep -a Alias|awk '{print $2}'"
  channel_alias = pear_run(command_alias)
  if channel_alias.empty?
    raise "Could not find alias for #{channel}"
  end
  Chef::Log.debug("Channel: #{channel}, Alias: #{channel_alias}")

  # avoid roundtrip to channel if it's installed
  if action == 'install_if_missing'
    p_count = pear_run("#{pear} list -c #{channel_alias}|grep -a #{package}|wc -l")
    if p_count.to_i > 0
      Chef::Log.debug("PEAR package #{package} is already installed.")
      return
    end
    action = "install"
  end

  # force whatever comes next (probably a good idea)
  f_param = ""
  if force == true
    f_param = " -f"
  end

  # version string
  version_str = ""
  if version && !version.empty?
    version_str = "-#{version}"
  end

  complete_command = "#{pear} #{action}#{f_param} #{channel_alias}/#{package}#{version_str}"
  execute "PEAR: run #{action}: #{complete_command}" do
    command complete_command
  end
end

action :install do
  pear_cmd(@pear_cmd, "install", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
  new_resource.updated_by_last_action(true)
end

action :uninstall do
  pear_cmd(@pear_cmd, "uninstall", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
  new_resource.updated_by_last_action(true)
end

action :upgrade do
  pear_cmd(@pear_cmd, "upgrade", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
  new_resource.updated_by_last_action(true)
end

action :install_if_missing do
  pear_cmd(@pear_cmd, "install_if_missing", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
  new_resource.updated_by_last_action(true)
end
