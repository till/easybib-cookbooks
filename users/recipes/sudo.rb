# install a config for easybib
if node[:users]
  template "/etc/sudoers.d/easybib" do
    source "sudoers-easybib.erb"
    mode   "0440"
    variables({
      :users => node[:users]
    })
  end
end
