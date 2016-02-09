# Cookbook Name:: vagrant
# Provider:: plugin

# Copyright 2015 Joshua Timberman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
use_inline_resources if defined?(:use_inline_resources)

# Support whyrun
def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::VagrantPlugin.new(new_resource)

  installed_version = plugin.installed_version

  if installed_version
    current_resource.installed(true)
    current_resource.installed_version(installed_version)
  end

  current_resource
end

action :install do
  unless target_version_installed?
    converge_by("Installing Vagrant plugin: #{new_resource.name} #{new_resource.version}") do
      plugin.install(new_resource.version, Array(new_resource.sources))
    end
  end
end

action :remove do
  uninstall
end

action :uninstall do
  uninstall
end

private

def plugin
  is_windows = node['platform_family'] == 'windows'
  @plugin ||= Vagrant::Plugin.new(
    new_resource.plugin_name,
    is_windows,
    username: new_resource.user,
    password: new_resource.password
  )
end

def uninstall
  if current_resource.installed
    converge_by("Uninstalling Vagrant plugin: #{new_resource.name} #{new_resource.version}") do
      plugin.uninstall
    end
  end
end

def version_match
  return true unless new_resource.version

  new_resource.version == current_resource.installed_version
end

def target_version_installed?
  current_resource.installed && version_match
end
