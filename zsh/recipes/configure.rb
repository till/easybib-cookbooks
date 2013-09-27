# this is for vagrant

#database_credentials = []
#if node["gocourse"]["database"]
#  database_credentials = node["gocourse"]["database"]
#end

template "/etc/zsh/zprofile" do
  source "zprofile.erb"
  mode   "0755"
  variables :vars => node["gocourse"]["env"]
  not_if do
    node["gocourse"]["env"].nil? || node["gocourse"]["env"].empty?
  end
end
