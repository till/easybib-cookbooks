include_recipe 'easybib::role-phpapp'

include_recipe 'php-mysqli::configure'
include_recipe 'php-gearman'
include_recipe 'php-posix'
include_recipe 'php-poppler-pdf'
include_recipe 'php-intl'
include_recipe 'easybib-deploy::easybib'
include_recipe 'pecl-manager::vagrant'

unless is_aws
  # we use our recipe instead of the default package, because
  # our recipe writes data to disk instead of memory, so it survives
  # a vagrant suspend
  include_recipe 'redis::default'

  gearmanconf_root_dir = ::File.expand_path(node['easybib_deploy']['gearman_root'])
  import_file_path = "#{gearmanconf_root_dir}/deploy/#{node['easybib_deploy']['gearman_file']}"

  pecl_manager_script 'Setting up Pecl Manager Script for vagrant' do
    dir gearmanconf_root_dir
    envvar_file import_file_path
    envvar_json_source node['easybib_deploy']['env_source']
    only_if { ::File.exist?(import_file_path) }
  end
end
