name 'ohai'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Distributes a directory of custom ohai plugins'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.4'

recipe 'ohai::default', 'Distributes a directory of custom ohai plugins'

source_url 'https://github.com/chef-cookbooks/ohai' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/ohai/issues' if respond_to?(:issues_url)

%w(ubuntu debian centos redhat amazon scientific fedora oracle).each do |os|
  supports os
end

attribute 'ohai/plugin_path',
  display_name: 'Ohai Plugin Path',
  description: 'Distribute plugins to this path.',
  type: 'string',
  required: 'optional',
  default: '/etc/chef/ohai_plugins'

attribute 'ohai/plugins',
  display_name: 'Ohai Plugin Sources',
  description: 'Read plugins from these cookbooks and paths',
  type: 'hash',
  required: 'optional',
  default: { 'ohai' => 'plugins' }
