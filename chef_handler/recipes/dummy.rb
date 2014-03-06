include_recipe "chef_handler"

Chef::Log.info("#{node['chef_handler']['handler_path']}/dummy_handler.rb")

chef_handler "Chef::Handler::DummyHandler" do
  source "#{node['chef_handler']['handler_path']}/dummy_handler.rb"
  action :nothing
end.run_action(:enable)

chef_handler "Chef::Handler::Dummy2Handler" do
  source "#{node['chef_handler']['handler_path']}/dummy2_handler.rb"
  action :enable
end