include_recipe "deploy::source"


if node[:scalarium][:instance][:roles].include?('nginxphpapp')

  deploy = node[:deploy][:easybib]

elsif node[:scalarium][:instance][:roles].include?('bibapi')

  deploy = node[:deploy][:easybib_api]

elsif node[:scalarium][:instance][:roles].include?('easybibsolr')

  deploy = nil
  
else

  deploy = nil

end

if !deploy.nil?

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