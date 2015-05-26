require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

def load_current_resource
  @current_resource = Chef::Resource::VagrantPlugin.new(new_resource)
  vp = shell_out("vagrant plugin list")
  if vp.stdout.include?(new_resource.plugin_name)
    @current_resource.installed(true)
    @current_resource.installed_version(vp.stdout.split[1].gsub(/[\(\)]/, ''))
  end
  @current_resource
end

action :install do
  unless installed?
    plugin_args = ""
    plugin_args += "--plugin-version #{new_resource.version}" if new_resource.version
    shell_out("vagrant plugin install #{new_resource.plugin_name} #{plugin_args}")
    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  uninstall if @current_resource.installed
  new_resource.updated_by_last_action(true)
end

action :uninstall do
  uninstall if @current_resource.installed
  new_resource.updated_by_last_action(true)
end

def uninstall
  shell_out("vagrant plugin uninstall #{new_resource.plugin_name}")
end

def installed?
  @current_resource.installed && version_match
end

def version_match
  # if the version is specified, we need to check if it matches what
  # is installed already
  if new_resource.version
    @current_resource.installed_version == new_resource.version
  else
    # the version matches otherwise because it's installed
    true
  end
end
