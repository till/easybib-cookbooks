package "apt-mirror"

template "/etc/apt/mirror.list" do
  mode   0644
  source "mirror.list.erb"
end

# todo: enable cronjob?
