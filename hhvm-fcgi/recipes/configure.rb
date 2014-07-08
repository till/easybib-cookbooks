fcgi_conf = "#{node["hhvm-fcgi"]["prefix"]}#{node["hhvm-fcgi"]["inifile"]["fcgi"]}"
cli_conf  = "#{node["hhvm-fcgi"]["prefix"]}#{node["hhvm-fcgi"]["inifile"]["cli"]}"

if node["hhvm-fcgi"]["user"] == "vagrant"
  display_errors = "On"
else
  display_errors = "Off"
end

template fcgi_conf do
  mode     "0755"
  source   "php.ini.erb"
  variables(
    :enable_dl      => 'Off',
    :memory_limit   => node["hhvm-fcgi"]["memorylimit"],
    :display_errors => display_errors
  )
  owner    node["hhvm-fcgi"]["user"]
  group    node["hhvm-fcgi"]["group"]
  notifies :reload, "service[hhvm]", :delayed
end

template cli_conf do
  mode "0755"
  source "php.ini.erb"
  variables(
    :enable_dl      => "On",
    :memory_limit   => '1024M',
    :display_errors => 'On'
  )
  owner node["hhvm-fcgi"]["user"]
  group node["hhvm-fcgi"]["group"]
end

template "/etc/logrotate.d/hhvm" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :enable, "service[hhvm]"
  notifies :start, "service[hhvm]"
end
