def initialize(*args)
  super(*args)

  pear = `which pear`.strip

  if pear.empty?
    raise Chef::Exceptions::ShellCommandFailed, "PEAR is not installed, or not in the path."
  end

  @pear_cmd = pear

  Chef::Log.debug("Looks like we found a PEAR installer: #{@pear_cmd}")

  execute "PEAR: enable auto discover for channels" do
    command "#{pear} config-set auto_discover 1"
  end
end

def pear_cmd(cmd, p, f, c, v)
  execute "PEAR: discover #{c}" do
    command "#{@pear_cmd} channel-discover #{c}"
    not_if  "#{@pear_cmd} list-channels|grep #{c}"
  end

  # get the alias - BUT Y U NEED ALIAS?! - because when the channel is 'foo.example.org/pear' it screws up pear install
  c_alias = `pear list-channels|grep #{c}|awk '{print $2}'`.strip

  # avoid roundtrip to channel if it's installed
  if cmd == 'install_if_missing'
    p_count = Integer(`#{@pear_cmd} list -c #{c_alias}|grep #{p}|wc -l`.strip)
    if p_count > 0
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

  e = "#{@pear_cmd} #{cmd}#{f_param} #{c_alias}/#{p}#{v_str}"
  execute "PEAR: run #{cmd}" do
    command e
  end
end

action :install do
  pear_cmd("install", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
end
 
action :uninstall do
  pear_cmd("uninstall", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
end

action :upgrade do
  pear_cmd("upgrade", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
end

action :install_if_missing do
  pear_cmd("install_if_missing", new_resource.name, new_resource.force, new_resource.channel, new_resource.version)
end
