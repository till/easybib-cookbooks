desired_ruby_version = node.fetch('ies-ruby', {}).fetch('ruby', {}).fetch('desired_ruby', '')
gem_dependencies = node.fetch('ies-ruby', {}).fetch('ruby', {}).fetch('gems', [])
Chef::Application.fatal!('No desired Ruby version selected via node-attributes!') unless desired_ruby_version

ies_ruby_deploy desired_ruby_version

ies_ruby_gems desired_ruby_version do
  gems gem_dependencies
  only_if do
    gem_dependencies
  end
end
