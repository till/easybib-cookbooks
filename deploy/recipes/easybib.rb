# custom recipe because of: http://support.scalarium.com/discussions/problems/78-app-is-not-deploying

deployUser="www-data"

Chef::Log.debug("deploy::easybib - entered.");

node[:deploy].each do |application, deploy|

  Chef::Log.debug("deploy::easybib - app: #{application}, role: #{node[:scalarium][:instance][:roles]}")

  case application
  when 'easybib'
    next unless node[:scalarium][:instance][:roles].include?('nginxphpapp')
  when 'easybib_api'
    next unless node[:scalarium][:instance][:roles].include?('bibapi')
  when 'easybib_solr_research_importers'
    # not sure on which roles you want to have this app
    next unless node[:scalarium][:instance][:roles].include?('easybibsolr')

    Chef::Log.debug('deploy::easybib - Setting deploy for RESEARCH IMPORTERS')
    
    deploy[:deploy_to]       = "/solr/research_importers"
    deploy[:restart_command] = ""

  when 'easybib_solr_server'
    # not sure on which roles you want to have this app
    next unless node[:scalarium][:instance][:roles].include?('easybibsolr')

    Chef::Log.debug('deploy::easybib - Setting deploy for SOLR SERVER')

    deploy[:deploy_to]       = "/solr/apache-solr-1.4.1-compiled"
    deploy[:restart_command] = ""

    deployUser = "root"

  when 'realtime'
    next unless node[:scalarium][:instance][:roles].include?('nodejsapp')

    deployUser = "root"

    # this is from deploy::scm
    Chef::Log.debug('deploy.easybib - Prepare for git checkout')
    prepare_git_checkouts(
      :user    => deployUser,
      :group   => deployUser,
      :home    => "/root",
      :ssh_key => deploy[:scm][:ssh_key]
    )

    Chef::Log.debug('deploy::easybib - Setting deploy for node.js')

    deploy[:restart_command] = "restart realtime"

  end

  Chef::Log.debug("deploy::easybib - CREATE DEPLOY DIR")

  directory deploy[:deploy_to] do
    owner "root"
    group "root"
    mode "0755"
    action :create
    recursive true
    not_if "test -d #{deploy[:deploy_to]}"
  end

  Chef::Log.debug("deploy::easybib - ABOUT TO DEPLOY FOR REALZ")
  
  # we survived until here - so we are good to actually checkout and deploy
  # done for every app
  
  # chef bug
  directory "#{deploy[:deploy_to]}/shared/cached-copy" do
    recursive true
    action :delete
  end
  
  # setup deployment & checkout
  deploy deploy[:deploy_to] do

    case deploy[:scm][:scm_type]
      when 'git'
        scm_provider Chef::Provider::Git

      when 'svn'
        # fix svn url
        unless deploy[:scm][:revision].match(/(r[0-9]{1,})|([0-9]{1,})|(HEAD)/)
          deploy[:scm][:repository] = "#{deploy[:scm][:repository]}/#{deploy[:scm][:revision]}"
          deploy[:scm][:revision]   = nil
        end

        scm_provider Chef::Provider::Subversion
        svn_username deploy[:scm][:user]
        svn_password deploy[:scm][:password]
        svn_arguments "--no-auth-cache --non-interactive"

    end

    repository deploy[:scm][:repository]
    user deployUser

    if !deploy[:scm][:revision].nil?
      revision deploy[:scm][:revision]
    end

    symlink_before_migrate({})
    migrate false
    #if !node[:scalarium][:instance][:roles].include?('easybibsolr')
    #  migrate deploy[:migrate]
    #  migration_command deploy[:migrate_command]
    #end

    action deploy[:action]

    if deploy[:restart_command].any?
      restart_command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
    end
    
  end
  
end
