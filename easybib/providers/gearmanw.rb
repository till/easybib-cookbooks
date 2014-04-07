action :create do
  application_root_dir = new_resource.application_root_dir
  envvar_json_source   = new_resource.envvar_json_source

  import_file = "#{application_root_dir}/deploy/#{node['easybib_deploy']['gearman_file']}"

  if ::File.exists?(import_file)

    Chef::Log.debug("easybib_gearmanw - found gearmanw file, setting up")

    p = pecl_manager_script "Setting up Pecl Manager" do
      dir                application_root_dir
      envvar_file        import_file
      envvar_json_source new_resource.envvar_json_source
    end

    if p.updated_by_last_action?

    end

    new_resource.updated_by_last_action(p.updated_by_last_action?)

  else
    Chef::Log.debug("easybib_gearmanw - no gearmanw file at #{import_file} found, skipping")
  end

end
