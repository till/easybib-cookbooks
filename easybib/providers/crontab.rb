action :create do
  app = new_resource.app
  crontab_file = new_resource.crontab_file

  updated = false

  unless ::File.exist?(crontab_file)
    new_resource.updated_by_last_action(updated)
    next
  end

  execute 'Clear old crontab' do
    user node['nginx-app']['user']
    # crontab will exit with 130 if crontab has already been cleared
    # adding a "; true" to remove the loooong warning in chef logs everyone stumbles upon
    command "crontab -u #{node['nginx-app']['user']} -r; true"
    ignore_failure true
    only_if do
      ::File.exist?(crontab_file)
    end
  end

  execute 'Clear old cron.d files' do
    # rm will exit with 1 if no old cron.d files existed
    # adding a "; true" to remove the loooong warning in chef logs everyone stumbles upon
    command "rm /etc/cron.d/#{app}_*; true"
    ignore_failure true
  end

  Chef::Log.info("easybib_deploy - importing cronjobs from #{crontab_file}")

  create_crontab = ::EasyBib.deploy_crontab?(
    new_resource.instance_roles,
    new_resource.cronjob_role
  )
  if create_crontab
    cron = ::EasyBib::Cron.new(app, crontab_file)

    cron.parse!.to_enum.with_index(1).each do |crontab, cron_counter|
      Chef::Log.info("easybib_deploy - crontabline: #{crontab}")

      updated = true
      cron_name = cron.get_name(cron_counter)

      Chef::Log.info("easybib_deploy - installing crontab file #{cron_name}")

      cron_d cron_name do
        action :create
        minute crontab[1]
        hour crontab[2]
        day crontab[3]
        month crontab[4]
        weekday crontab[5]
        user node['nginx-app']['user']
        command crontab[6]
        path node['easybib_deploy']['cron_path']
      end

      Chef::Log.info("easybib_deploy - I just called cron_d for #{cron_name}")

    end
  else
    Chef::Log.info('easybib_deploy - I did not install cronjobs because deploy_crontab returned false')
  end

  new_resource.updated_by_last_action(updated)

end
