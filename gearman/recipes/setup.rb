execute "add-drizzle-ppa" do
  command "add-apt-repository ppa:drizzle-developers/ppa"
  creates "/etc/apt/sources.list.d/drizzle-developers-ppa-lucid.list"
end

package "libgearman4"
package "gearman-job-server"

service "gearman-job-server" do
  service_name "gearman-job-server"

  supports :status => false, :restart => true, :reload => false, "force-reload" => true
  action :enable
end

include_recipe "gearman::configure"
