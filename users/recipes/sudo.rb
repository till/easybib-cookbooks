# install a config for easybib
template "/etc/sudoers.d/easybib" do
  source "sudoers-easybib.erb"
  mode   "0440"
  variables({
    :users => node[:users]
  })
  only_if do
    attribute?("users") && !node["users"].empty?
  end
end
