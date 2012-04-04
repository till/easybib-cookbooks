template "/usr/local/etc/php/xdebug.ini" do
  source "xdebug.ini.erb"
  mode   "0644"
  variables(
    :config => node[:xdebug][:config]
  )
end
