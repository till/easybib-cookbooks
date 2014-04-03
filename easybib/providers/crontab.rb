action :create do
  app = new_resource.app
  crontab_file = new_resource.crontab_file

  updated = false

  if ::File.exists?(crontab_file)

    execute "Clear old crontab" do
      user "www-data"
      # crontab will exit with 130 if crontab has already been cleared, hence the ;true
      command "crontab -u www-data -r; true"
    end

    CRON_REGEX = '([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +(.*)'

    Chef::Log.info("easybib_deploy - importing cronjobs from #{crontab_file}")

    crontabs = ::File.open(crontab_file)
    cron_counter = 1

    crontabs.each_line do |line|
      crontab = line.match(CRON_REGEX)
      Chef::Log.info("easybib_deploy - crontabline: #{crontab}")
      next unless crontab

      updated = true
      cron_name = "#{app}_#{cron_counter}"

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

      cron_counter += 1

    end
  else
    Chef::Log.info("easybib_deploy - crontab file not found at #{crontab_file}, skipping")
  end

  new_resource.updated_by_last_action(updated)

end
