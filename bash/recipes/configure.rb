database_credentials = []
if node["gocourse"] && node["gocourse"]["database"]
  database_credentials = node["gocourse"]["database"]
end

template "/etc/profile.d/gocourse.sh" do
  source "profile.erb"
  mode "0755"
  variables :vars => database_credentials

  not_if do
    database_credentials.empty?
  end
end

cookbook_file "/etc/profile.d/bib-alias.sh" do
  source "alias.sh"
  mode   "0755"
end
