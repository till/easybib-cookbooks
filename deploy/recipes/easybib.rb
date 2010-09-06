include_recipe "deploy::source"


if node[:scalarium][:instance][:roles].include?('nginxphpapp')

  deploy = node[:deploy][:easybib]

elsif node[:scalarium][:instance][:roles].include?('bibapi')

  deploy = node[:deploy][:easybib_api]

elsif node[:scalarium][:instance][:roles].include?('easybibsolr')

  node[:deploy].each do |application, deployInfo|

    # -server and -research importers
    if application == "easybib_solr_research_importers"

      deploy                   = deployInfo
      deploy[:deploy_to]       = "/solr/research_importers"
      deploy[:restart_command] = ""

      break

    end

    if application == "easybib_solr_server"

      deploy                   = deployInfo
      deploy[:deploy_to]       = "/solr/apache-solr-1.4-compiled"
      deploy[:restart_command] = "/etc/init.d/solr restart"

      break

    end

    Chef::Log.debug("Skipping deploy::easybib because application #{application} doesn't. run on #{node[:scalarium][:instance][:roles]}")

  end

else

  deploy = nil

end

# This fixes a Scalarium bug:
# UI asks for branch or revision but is only able to deal with revisions.
matches = deploy[:scm][:revision].match(/(r[0-9]{1,})|([0-9]{1,})/)
if matches.nil? 

  deploy[:scm][:repository] = "#{deploy[:scm][:repository]}/#{deploy[:scm][:revision]}"
  deploy[:scm][:revision]   = nil

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

    if deploy[:scm][:revision].any?
      revision deploy[:scm][:revision]
    end

    migrate deploy[:migrate]
    migration_command deploy[:migrate_command]

    symlink_before_migrate deploy[:symlink_before_migrate]
    action deploy[:action]

    if deploy[:restart_command].any?
      restart_command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
    end

    scm_provider Chef::Provider::Subversion
    svn_username deploy[:scm][:user]
    svn_password deploy[:scm][:password]
    svn_arguments "--no-auth-cache"

  end

end