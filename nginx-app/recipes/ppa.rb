include_recipe "apt::ppa"

easybib_launchpad "ppa:nginx/stable" do
  action :discover
end
