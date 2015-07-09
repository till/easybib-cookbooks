easybib_supervisor 'some-app' do
  app 'some-app'
  app_dir '/foo/bar'
  supervisor_file '/some_file'
  user 'some-user'
  supervisor_role 'housekeeping'
  instance_roles ["role1", "role2"]
end
