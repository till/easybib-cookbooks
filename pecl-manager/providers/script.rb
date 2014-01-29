action :create do
  root_dir = new_resource.dir

  # TODO we should add a "if file exists" check here

  unless new_resource.envvar_json_source.nil
    global_envvars = ::EasyBib.get_env_for_shell(new_resource.envvar_json_source, node)
  end
  
  template "/etc/init.d/pecl-manager" do
    cookbook "pecl-manager"
    source "init.d.erb"
    mode "0700"
    owner "root"
    group "root"
    variables(
      :dir => root_dir,
      :envvar_file => new_resource.envvar_file,
      :envvars => global_envvars
    )
  end

  service "pecl-manager" do
    supports [ :start, :stop, :restart, :status ]
    action :restart
  end

  new_resource.updated_by_last_action(true)

end
