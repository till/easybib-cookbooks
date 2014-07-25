# Add hints_path from node attributes if missing.
unless Ohai::Config[:hints_path].include?(node['ohai']['hints_path'])
  Ohai::Config[:hints_path] = [node['ohai']['hints_path'], Ohai::Config[:hints_path]].flatten.compact
end
Chef::Log.info("ohai hints will be at: #{node['ohai']['hints_path']}")

hint_resource = ohai_hint 'test' do
  content Hash[:a, 'hogehoge']
end

hint_resource.run_action(:create)

test_plugin_content =<<__EOL__
provides 'hint_tester'

if hint?(:test)
  test_hint 'Ohai Chefs!'
else
  test_hint 'Bye Chefs..'
end
__EOL__



file File.join(node[:ohai][:plugin_path], 'test.rb') do
  content test_plugin_content
end.run_action(:create)


if hint_resource.updated_by_last_action?
  ohai 'custom_hints' do
    action :nothing
  end.run_action(:reload)
end
