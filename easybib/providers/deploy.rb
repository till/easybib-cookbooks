action :deploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  application_root_dir = "#{deploy_data['deploy_to']}/current"
  crontab_path = "#{deploy_data['deploy_to']}/current/deploy/crontab"

  opsworks_deploy do
    deploy_data deploy_data
    app app
  end

  if ::File.exists?(crontab_path)

    execute "Clear old crontab" do
      user "www-data"
      # crontab will exit with 130 if crontab has already been cleared, hence the ;true
      command "crontab -u www-data -r; true"
    end

    CRON_REGEX = '([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +(.*)'

    Chef::Log.debug("easybib_deploy - importing cronjobs from #{crontab_path}")

    crontabs = ::File.open(crontab_path)
    cron_counter = 1

    crontabs.each_line do |line|
      crontab = line.match(CRON_REGEX)
      next unless crontab

      cron_name = "#{app}_#{cron_counter}"

      Chef::Log.debug("easybib_deploy - installing crontab file #{cron_name}")

      cron_d cron_name do
        action :create
        minute crontab[1]
        hour crontab[2]
        day crontab[3]
        month crontab[4]
        weekday crontab[5]
        user "www-data"
        command crontab[6]
      end

      cron_counter += 1

    end
  else
    Chef::Log.debug("easybib_deploy - crontab file not found at #{crontab_path}, skipping")
  end

  import_file_path = "#{application_root_dir}/deploy/#{node['easybib_deploy']['gearman_file']}"

  Chef::Log.debug("easybib_deploy - import_file_path we are looking for is #{import_file_path}")

  pecl_manager_script "Setting up Pecl Manager" do
    dir                application_root_dir
    envvar_file        import_file_path
    envvar_json_source new_resource.envvar_json_source
    only_if { ::File.exists?(import_file_path) }
  end

  new_resource.updated_by_last_action(true)

end
