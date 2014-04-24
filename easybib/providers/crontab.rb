action :create do
  app = new_resource.app
  crontab_file = new_resource.crontab_file

  updated = false

  execute "Clear old crontab" do
    user "www-data"
    # crontab will exit with 130 if crontab has already been cleared, hence the ;true
    command "crontab -u www-data -r; true"
    only_if do
      ::File.exists?(crontab_file)
    end
  end

  Chef::Log.info("easybib_deploy - importing cronjobs from #{crontab_file}")

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
      user "www-data"
      command crontab[6]
      path node["easybib_deploy"]["cron_path"]
    end

    Chef::Log.info("easybib_deploy - I just called cron_d for #{cron_name}")

  end

  new_resource.updated_by_last_action(updated)

end
