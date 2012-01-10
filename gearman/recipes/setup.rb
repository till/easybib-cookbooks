execute "add-drizzle-ppa" do
  command "add-apt-repository ppa:drizzle-developers/ppa"
  creates "/etc/apt/sources.list.d/drizzle-developers-ppa-lucid.list"
end

package "libgearman4"
package "gearman-job-server"

include_recipe "gearman::configure"
