easybib_supervisor 'some-app' do
  app_dir '/foo/bar'
  supervisor_file '/some_file'
  user 'some-user'
  supervisor_role 'housekeeping'
  instance_roles %w(role1 housekeeping)
end
