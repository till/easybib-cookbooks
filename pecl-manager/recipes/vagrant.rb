unless is_aws
  import_file_path = "/vagrant_data/deploy/#{node['easybib_deploy']['gearman_file']}"

  pecl_manager_script "Setting up Pecl Manager Script for vagrant" do
    dir "/vagrant_data"
    envvar_file import_file_path
    envvar_source node['easybib_deploy']['env_source']
    only_if { ::File.exists?(import_file_path) }
  end
end
