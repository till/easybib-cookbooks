unless is_aws
  import_file_path = "/vagrant_gearman/deploy/#{node['easybib_deploy']['gearman_file']}"
  pecl_manager_script 'Setting up Pecl Manager Script for vagrant' do
    dir '/vagrant_gearman'
    envvar_file import_file_path
    only_if { ::File.exist?(import_file_path) }
  end
end
