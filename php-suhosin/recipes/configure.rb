include_recipe "php-fpm::service"

etc_dir = "#{node["php-fpm"]["prefix"]}/etc/php"

template "#{etc_dir}/suhosin.ini" do
  source   "suhosin.ini.erb"
  mode     "0644"
  notifies :reload, "service[php-fpm]", :delayed
  only_if is_suhosin_available?
end

def is_suhosin_available
  check_cmd = Mixlib::ShellOut.new("dpkg -s php5-easybib-suhosin")
  check_cmd.run_command
  check_cmd.exitstatus == 0
end
