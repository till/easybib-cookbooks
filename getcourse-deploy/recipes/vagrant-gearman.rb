if is_aws
  Chef::Application.fatal!('This recipe is vagrant only')
end

gearmanconf_root_dir = ::File.expand_path("#{node['vagrant']['deploy_to']['api']}/..")
import_file_path = "#{gearmanconf_root_dir}/deploy/#{node['easybib_deploy']['gearman_file']}"

pecl_manager_script "Setting up Pecl Manager Script for vagrant" do
  dir gearmanconf_root_dir
  envvar_file import_file_path
  envvar_json_source node['easybib_deploy']['env_source']
  only_if { ::File.exists?(import_file_path) }
end
