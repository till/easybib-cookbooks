action :create do
  root_dir = new_resource.dir

  # TODO: we should add a "if file exists" check here

  Chef::Log.debug("Pecl-Manager: Importing file #{new_resource.envvar_file} in Startscript")

  # clean up old links to bin/worker
  link '/etc/init.d/pecl-manager' do
    action :delete
    only_if 'test -L /etc/init.d/pecl-manager'
  end

  t = template '/etc/init.d/pecl-manager' do
    cookbook 'pecl-manager'
    source 'init.d.erb'
    mode  '0700'
    owner 'root'
    group 'root'
    variables(
      :dir => root_dir,
      :envvar_file => new_resource.envvar_file,
      :gearman_user => node['pecl-manager']['user']
    )
  end

  if node.attribute?('vagrant')
    service 'pecl-manager' do
      supports [:start, :stop, :restart, :status]
      action :restart
      ignore_failure true
    end
  else
    service 'pecl-manager' do
      supports [:start, :stop, :restart, :status]
      action :restart
    end
  end

  new_resource.updated_by_last_action(t.updated_by_last_action?)
end
