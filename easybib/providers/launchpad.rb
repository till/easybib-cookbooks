action :discover do

  repository = new_resource.repository

  discover_command = "add-apt-repository --yes "
  discover_command << repository

  execute "discover ppa: #{repository}" do
    command discover_command
    notifies :run, "execute[update_easybib_sources]", :immediately
  end

  execute "update_easybib_sources" do
    command "apt-get -y -f -q update"
    action :nothing
  end

  new_resource.updated_by_last_action(true)

end
