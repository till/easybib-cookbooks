action :create do
  dir = new_resource.dir

  global_envvars = ::EasyBib.get_env_for_shell(new_resource.envvar_source, node) unless new_resource.envvar_source.nil?

  template "/etc/init.d/pecl-manager" do
    cookbook "pecl-manager"
    source "init.d.erb"
    mode "0700"
    owner "root"
    group "root"
    variables(
      :dir => dir,
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
