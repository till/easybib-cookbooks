include_recipe "easybib::role-phpapp"

include_recipe "php-posix"
include_recipe "php-zip"
include_recipe "php-intl"
include_recipe "php-gearman"
include_recipe "php-mysqli::configure"

include_recipe "snooze"
include_recipe "bash::bashrc"
include_recipe "bash::configure"
include_recipe "deploy::getcourse-api"
include_recipe "nginx-app::getcourse-api"

unless is_aws
  gearmanconf_root_dir = ::File.expand_path("#{node['vagrant']['deploy_to']['api']}/..")
  import_file_path = "#{gearmanconf_root_dir}/deploy/#{node['easybib_deploy']['gearman_file']}"

  pecl_manager_script "Setting up Pecl Manager Script for vagrant" do
    dir gearmanconf_root_dir
    envvar_file import_file_path
    envvar_json_source node['easybib_deploy']['env_source']
    only_if { ::File.exists?(import_file_path) }
  end
end
