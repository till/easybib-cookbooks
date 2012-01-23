execute "apt_get_update" do
  command "apt-get update"
  action :nothing
end

execute "add-drizzle-ppa" do
  command "add-apt-repository ppa:drizzle-developers/ppa"
  creates "/etc/apt/sources.list.d/drizzle-developers-ppa-lucid.list"
  notifies :run, "execute[apt_get_update]", :immediately
end

package "libgearman4"
package "gearman-job-server"

service "gearman-job-server" do
  service_name "gearman-job-server"

  supports :status => false, :restart => true, :reload => false, "force-reload" => true
  action :enable
end

include_recipe "gearman::configure"
