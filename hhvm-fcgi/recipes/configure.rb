config = node["hhvm-fcgi"]["config"]

config.each do |type,settings|

  next if type == "hhvm"

  template "#{node["hhvm-fcgi"]["prefix"]}#{settings["file"]}" do
    mode     "0755"
    cookbook "php-fpm"
    source   "php.ini.erb"
    variables(
      :hhvm => settings["hhvm"],
      :enable_dl => settings["enable_dl"],
      :memory_limit => settings["memory_limit"],
      :display_errors => settings["display_errors"],
      :max_execution_time => settings["max_execution_time"],
      :logfile => node["hhvm-fcgi"]["logfile"],
      :tmpdir => node["hhvm-fcgi"]["tmpdir"],
      :prefix => node["hhvm-fcgi"]["prefix"]
    )
    owner node["hhvm-fcgi"]["user"]
    group node["hhvm-fcgi"]["group"]
    notifies :restart, "service[hhvm]", :delayed
  end
end

template "#{node["hhvm-fcgi"]["prefix"]}#{config["hhvm"]["file"]}" do
  mode "0755"
  source "config.hdf.erb"
  variables(
    :display_errors => config["hhvm"]["display_errors"]
  )
  owner node["hhvm-fcgi"]["user"]
  group node["hhvm-fcgi"]["group"]
end

template "/etc/logrotate.d/hhvm" do
  cookbook "php-fpm"
  source "logrotate.erb"
  variables(
    :logfile => node["hhvm-fcgi"]["logfile"]
  )
  mode "0644"
  owner "root"
  group "root"
  notifies :enable, "service[hhvm]"
  notifies :start, "service[hhvm]"
end
