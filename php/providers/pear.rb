def initialize(*args)
  super(*args)

  pear = pear_run("which pear").strip

  if pear.empty?
    raise Chef::Exceptions::ShellCommandFailed, "PEAR is not installed, or not in the path."
  end

  @pear_cmd = pear

  Chef::Log.debug("Looks like we found a PEAR installer: #{@pear_cmd}")

  execute "PEAR: enable auto discover for channels" do
    command "#{@pear_cmd} config-set auto_discover 1"
  end
end

def pear_run(cmd)
  cmd = Chef::ShellOut.new(cmd)
  return cmd.run_command.stdout.strip
end

def pear_cmd(pear, cmd, p, f, c, v)

  execute "PEAR: discover #{c}" do
    command "#{pear} channel-discover #{c}"
    not_if  "#{pear} list-channels|grep #{c}"
  end

  # get the alias - BUT Y U NEED ALIAS?! - because when the channel is 'foo.example.org/pear' it screws up pear install
  command_alias = "#{pear} channel-info #{c}|grep Alias|awk '{print $2}'"
  Chef::Log.debug("Trying to get alias of the PEAR channel: #{command_alias}")

  c_alias = pear_run(command_alias)
  Chef::Log.debug("Channel: #{c}, Alias: #{c_alias}")

  # avoid roundtrip to channel if it's installed
  if cmd == 'install_if_missing'
    p_count = pear_run("#{pear} list -c #{c_alias}|grep #{p}|wc -l")
    if Integer(p_count) > 0
      Chef::Log.debug("PEAR package #{p} is already installed.")
      return
    end
    cmd = "install"
  end

  # force whatever comes next (probably a good idea)
  f_param = ""
  if f == true
    f_param = " -f"
  end

  # version string
  v_str = ""
  if v 
    v_str = "-#{v}"
  end

  complete_command = "#{pear} #{cmd}#{f_param} #{c_alias}/#{p}#{v_str}"
  Chef::Log.debug(complete_command)
  execute "PEAR: run #{cmd}: #{complete_command}" do
    command complete_command
  end
end

action :install do
  pear_cmd(@pear_cmd, "install", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
end
 
action :uninstall do
  pear_cmd(@pear_cmd, "uninstall", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
end

action :upgrade do
  pear_cmd(@pear_cmd, "upgrade", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
end

action :install_if_missing do
  pear_cmd(@pear_cmd, "install_if_missing", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
end
