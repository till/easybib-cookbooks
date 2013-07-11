database_credentials = []
if node["gocourse"]["database"]
  database_credentials = node["gocourse"]["database"]
end

if database_credentials && !database_credentials.empty?
  template "/etc/profile.d/gocourse.sh" do
      source "profile.erb"
      mode   "0755"
      variables :vars => database_credentials
  end
end
