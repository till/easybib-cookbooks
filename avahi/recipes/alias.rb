include_recipe "avahi::alias-service"

["python-avahi", "python-pip"].each do |pkg|
  package pkg
end

execute "update pip" do
  command "pip install --upgrade pip"
  only_if do
    `pip -V`.split(' ')[1] != '1.5'
  end
end

execute "install python-avahi" do
  command "pip install --no-use-wheel --force-reinstall #{node["avahi"]["alias"]["package"]}"
end

template "/etc/avahi/aliases.d/domains" do
  mode "0644"
  source "alias.erb"
  variables({
    :domains => node["avahi"]["alias"]["domains"]
  })
  notifies :restart, "service[avahi-aliases]"
  notifies :restart, "service[nscd]"
  not_if do
    node["avahi"]["alias"]["domains"].empty?
  end
end
