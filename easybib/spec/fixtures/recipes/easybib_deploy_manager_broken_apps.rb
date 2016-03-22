execute 'foo' do
  command "echo 'foo'"
  action :nothing
end

easybib_deploy_manager 'fixtures' do
  apps node['fixtures']['applications']
  deployments node['deploy']
  action :deploy
  notifies :run, 'execute[foo]'
end
