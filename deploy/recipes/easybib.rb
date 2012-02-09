# custom recipe because of: http://support.scalarium.com/discussions/problems/78-app-is-not-deploying

deploy_user    = "www-data"
instance_roles = node[:scalarium][:instance][:roles]
cluster_name   = node[:scalarium][:cluster][:name]

node[:deploy].each do |application, deploy|

  Chef::Log.debug("deploy::easybib - app: #{application}, role: #{instance_roles}")

  case application
  when 'easybib'
    if cluster_name != 'EasyBib' && cluster_name != 'EasyBib Playground'
      next
    end
    if !instance_roles.include?('nginxphpapp') && !instance_roles.include?('testapp')
      next
    end

  when 'admedia'
    next unless instance_roles.include?('admedia')

  when 'easybib_api'
    next unless instance_roles.include?('bibapi')

  when 'easybib_solr_research_importers'
    if cluster_name != 'Research Cloud'
      next
    end
    next unless instance_roles.include?('easybibsolr')

    Chef::Log.debug('deploy::easybib - Setting deploy for RESEARCH IMPORTERS')

    # fix this: deploy to instance storage
    deploy[:deploy_to]       = "/solr/research_importers"
    deploy[:restart_command] = ""

  when 'easybib_solr_server'
    if cluster_name != 'Research Cloud'
      next
    end
    next unless instance_roles.include?('easybibsolr')

    Chef::Log.debug('deploy::easybib - Setting deploy for SOLR SERVER')

    # fix this: deploy to instance storage
    deploy[:deploy_to]       = "/solr/apache-solr-1.4.1-compiled"
    deploy[:restart_command] = ""

    deploy_user = "root"

  when 'research_app'
    if cluster_name != 'Research Cloud'
      next
    end
    next unless instance_roles.include?('nginxphpapp')

  when 'citationbackup'
    if cluster_name != 'Research Cloud'
      next
    end
    next unless instance_roles.include?('backup')

  when 'citation_anlytics'
    if cluster_name != 'Citation Analytics'
      next
    end
    next unless instance_roles.include?('elasticsearch')

    Chef::Log.debug('deploy.easybib - Prepare for git checkout')
    prepare_git_checkouts(
      :user    => deploy_user,
      :group   => deploy_user,
      :home    => "/var/www",
      :ssh_key => deploy[:scm][:ssh_key]
    )

  when 'gearmanworker'
    next unless instance_roles.include?('gearman-worker')

  when 'sitescraper'
    next unless instance_roles.include?('sitescraper')

  when 'research'
    if cluster_name != 'Research Cloud'
      next
    end

    next unless instance_roles.include?('nginxphpapp')

  else
    Chef::Log.debug("deploy::easybib - #{application} (in #{cluster_name}) skipped")
    next

  end

  directory deploy[:deploy_to] do
    owner "root"
    group "root"
    mode "0755"
    action :create
    recursive true
    not_if "test -d #{deploy[:deploy_to]}"
  end

  Chef::Log.debug("deploy::easybib - Deployment started.")

  scalarium_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  # chef bug
  directory "#{deploy[:deploy_to]}/shared/cached-copy" do
    recursive true
    action :delete
  end

  ruby_block "change HOME to #{deploy[:home]} for source checkout" do
    block do
      ENV['HOME'] = "#{deploy[:home]}"
    end
  end

  # setup deployment & checkout
  deploy deploy[:deploy_to] do

    case deploy[:scm][:scm_type]
      when 'git'
        scm_provider Chef::Provider::Git

      when 'svn'
        # fix svn url
        if deploy[:scm][:revision] && !deploy[:scm][:revision].match(/(r[0-9]{1,})|([0-9]{1,})|(HEAD)/)
          deploy[:scm][:repository] = "#{deploy[:scm][:repository]}/#{deploy[:scm][:revision]}"
          deploy[:scm][:revision]   = nil
        end

        scm_provider Chef::Provider::Subversion
        svn_username deploy[:scm][:user]
        svn_password deploy[:scm][:password]
        svn_arguments "--no-auth-cache --non-interactive"

    end

    repository deploy[:scm][:repository]
    user deploy_user

    if !deploy[:scm][:revision].nil?
      revision deploy[:scm][:revision]
    end

    symlink_before_migrate({})
    migrate false

    action deploy[:action]

    if deploy[:restart_command].any?
      restart_command "sleep #{deploy[:sleep_before_restart]} && #{deploy[:restart_command]}"
    end

  end

  ruby_block "change HOME back to /root after source checkout" do
    block do
      ENV['HOME'] = "/root"
    end
  end

end
