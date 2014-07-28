action :discover do

  apt_package "install add-apt-repository" do
    package_name "python-software-properties"
    only_if { node['lsb']['release'].to_f < 14.04 }
  end

  apt_package "install add-apt-repository" do
    package_name "software-properties-common"
    not_if { node['lsb']['release'].to_f < 14.04 }
  end

  repository = new_resource.repository

  discover_command = "add-apt-repository --yes "
  discover_command << repository

  execute "discover ppa: #{repository}" do
    command discover_command
    notifies :run, "execute[update_easybib_sources]", :immediately
  end

  execute "update_easybib_sources" do
    command "apt-get -y -q update"
    action :nothing
  end

  new_resource.updated_by_last_action(true)

end
