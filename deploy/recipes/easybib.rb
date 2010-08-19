include_recipe "deploy::source"

Chef::Log.info("ohai")

node[:deploy].each do |application, deploy|

  # chef bug
  directory "#{deploy[:deploy_to]}/shared/cached-copy" do
    recursive true
    action :delete
  end

  # setup deployment & checkout
  deploy deploy[:deploy_to] do

    repository deploy[:scm][:repository]
    user "www-data"

    revision deploy[:scm][:revision]
    migrate deploy[:migrate]
    migration_command deploy[:migrate_command]

    symlink_before_migrate deploy[:symlink_before_migrate]
    action deploy[:action]

    restart_command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"

    scm_provider Chef::Provider::Subversion
    svn_username deploy[:scm][:user]
    svn_password deploy[:scm][:password]
    svn_arguments "--no-auth-cache"

  end
end