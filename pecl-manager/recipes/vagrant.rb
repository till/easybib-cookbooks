unless is_aws
  import_file_path = "#{node['easybib_deploy']['gearman_root']}/deploy/#{node['easybib_deploy']['gearman_file']}"

  pecl_manager_script "Setting up Pecl Manager Script for vagrant" do
    dir "/vagrant_www"
    envvar_file import_file_path
    envvar_json_source node['easybib_deploy']['env_source']
    only_if { ::File.exist?(import_file_path) }
  end
end
