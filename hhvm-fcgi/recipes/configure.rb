fcgi_conf  = "#{node["hhvm-fcgi"]["prefix"]}#{node["hhvm-fcgi"]["conf"]["fcgi"]}"
cli_conf   = "#{node["hhvm-fcgi"]["prefix"]}#{node["hhvm-fcgi"]["conf"]["cli"]}"
hhvm_conf  = "#{node["hhvm-fcgi"]["prefix"]}#{node["hhvm-fcgi"]["conf"]["hhvm"]}"

if node["hhvm-fcgi"]["user"] == "vagrant"
  display_errors = "On"
else
  display_errors = "Off"
end

template fcgi_conf do
  mode     "0755"
  cookbook "php-fpm"
  source   "php.ini.erb"
  variables(
    :hhvm           => true,
    :enable_dl      => 'Off',
    :memory_limit   => node["hhvm-fcgi"]["memorylimit"],
    :display_errors => display_errors,
    :max_execution_time => node["hhvm-fcgi"]["maxexecutiontime"],
    :logfile => node["hhvm-fcgi"]["logfile"],
    :tmpdir => node["hhvm-fcgi"]["tmpdir"],
    :prefix => node["hhvm-fcgi"]["prefix"]
  )
  owner    node["hhvm-fcgi"]["user"]
  group    node["hhvm-fcgi"]["group"]
  notifies :restart, "service[hhvm]", :delayed
end

template cli_conf do
  mode "0755"
  cookbook "php-fpm"
  source "php.ini.erb"
  variables(
    :enable_dl      => "On",
    :memory_limit   => '1024M',
    :display_errors => 'On',
    :max_execution_time => '-1',
    :logfile => node["hhvm-fcgi"]["logfile"],
    :tmpdir => node["hhvm-fcgi"]["tmpdir"],
    :prefix => node["hhvm-fcgi"]["prefix"]
  )
  owner node["hhvm-fcgi"]["user"]
  group node["hhvm-fcgi"]["group"]
end

template hhvm_conf do
  mode "0755"
  source "config.hdf.erb"
  variables(
    :display_errors => 'On'
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
