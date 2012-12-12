include_recipe "apt::ppa"
execute "add ppa:nginx/stable" do
  command "add-apt-repository ppa:nginx/stable"
end

execute "update sources" do
  command "apt-get -y -f -q update"
end

package 'nginx'

include_recipe "nginx-lb::configure"
