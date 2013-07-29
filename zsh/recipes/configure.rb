# this is for vagrant

database_credentials = []
if node["gocourse"]["database"]
  database_credentials = node["gocourse"]["database"]
end

template "/etc/zsh/zprofile" do
  source "zprofile.erb"
  mode   "0755"
  variables :vars => database_credentials
  not_if do
    database_credentials.empty?
  end
end
