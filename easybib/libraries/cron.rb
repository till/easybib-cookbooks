module EasyBib
  class Cron
    def initialize(app, file)
      @app = app
      @file = file
    end

    def get_name(count)
      "#{@app}_#{count}"
    end

    def parse!
      regex = '([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +([0-9/\-\*]+) +(.*)'

      ::Chef::Log.info("easybib_deploy - importing cronjobs from #{crontab_file}")

      crontabs = ::File.open(@file)
      cron_counter = 1

      collection = []

      crontabs.each_line do |line|
        crontab = line.match(regex)
        Chef::Log.info("easybib_deploy - crontabline: #{crontab}")
        next unless crontab

        collection.push(crontab)
      end

      collection
    end
  end
end
