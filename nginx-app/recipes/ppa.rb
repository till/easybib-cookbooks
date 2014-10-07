include_recipe 'apt::ppa'

apt_repository "nginx-ppa" do
  uri     node['nginx-app']['ppa']
end
