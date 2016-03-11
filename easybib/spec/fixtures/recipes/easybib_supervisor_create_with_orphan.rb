easybib_supervisor 'some-app' do
  app 'some-app'
  app_dir '/foo/bar'
  supervisor_file '/deploy/supervisor.json'
  user 'some-user'
  supervisor_role 'housekeeping'
  instance_roles %w(role1 housekeeping)
  action :create
end
