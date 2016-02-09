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

if defined?(ChefSpec)
  ChefSpec.define_matcher(:vagrant_plugin)

  def install_vagrant_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:vagrant_plugin, :install, resource_name)
  end

  def uninstall_vagrant_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:vagrant_plugin, :uninstall, resource_name)
  end

  def remove_vagrant_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:vagrant_plugin, :remove, resource_name)
  end
end
