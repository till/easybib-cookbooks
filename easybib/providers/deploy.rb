action :deploy do
  app = new_resource.app
  deploy_data = new_resource.deploy_data
  application_root_dir = "#{deploy_data['deploy_to']}/current"

  opsworks_deploy do
    deploy_data deploy_data
    app app
  end

  if ::File.exists?("#{deploy_data['deploy_to']}/current/deploy/crontab")

    execute "Clear old crontab" do
      user "www-data"
      command "crontab -u www-data -r"
    end

    CRON_REGEX = '([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +(.*)'

    crontabs = ::File.open("#{deploy_data['deploy_to']}/current/deploy/crontab")
    cron_counter = 1

    crontabs.each_line do |line|
      crontab = line.match(CRON_REGEX)
      next unless crontab

      cron_name = "#{app}_#{cron_counter}"

      cron_d cron_name do
        action :create
        minute crontab[0]
        hour crontab[1]
        day crontab[2]
        month crontab[3]
        weekday crontab[4]
        user "www-data"
        command crontab[5]
      end

    end
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
